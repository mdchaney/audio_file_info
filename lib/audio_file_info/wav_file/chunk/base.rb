# frozen_string_literal: true

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile
    class Chunk
      class Base
        attr_reader :chunk_type, :file_position, :length, :chunk_raw_content, :valid

        class << self
          attr_reader :recognized_chunk_types
        end

        @recognized_chunk_types = {}

        def self.inherited(subclass)
          AudioFileInfo::WavFile::Chunk::Base.recognized_chunk_types[subclass.to_s.split('::').last.downcase] = subclass
        end

        def self.chunk_for(file, prior_chunks)
          chunk_type = file.read(4)
          return nil unless chunk_type.size == 4
          chunk_type.strip!

          chunk_class = @recognized_chunk_types[chunk_type] || AudioFileInfo::WavFile::Chunk::Generic

          # Passing chunk type in here in case it's using "generic"
          chunk_class.new(file, chunk_type, prior_chunks)
        end

        def self.read_length(file)
          raw_length = file.read(4)
          return nil unless raw_length.size == 4
          raw_length.unpack('V').first
        end

        # This sets the standard chunk attributes.  It will return "nil"
        # if there isn't enough data available.
        def initialize(file, chunk_type)
          @file_position = file.pos - 4

          @length = self.class.read_length(file)
          return nil if @length.nil?

          @chunk_type = chunk_type

          self
        end

        # This uses @length to just skip the rest of the chunk.
        # If the chunk is an odd length it will skip the extra byte.
        def skip_chunk(file)
          file.seek(length + (length.odd? ? 1 : 0),IO::SEEK_CUR)
        end

        # This reads @length bytes from the file into @chunk_raw_content.
        # It will also skip a byte if @length is odd.  If there aren't
        # enough bytes available, it will return nil.
        def read_chunk(file)
          raw_content = file.read(length)
          return nil unless raw_content && raw_content.size == length
          file.seek(1, IO::SEEK_CUR) if length.odd?
          @chunk_raw_content = raw_content
        end
      end
    end
  end
end
