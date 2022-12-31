# frozen_string_literal: true

require_relative 'wav_file/chunk'

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile

    attr_reader :chunks

    EXTENSIONS = %w{ .wav }.freeze

    def self.can_handle_file?(ext)
      EXTENSIONS.include? ext
    end

    def initialize(original_filename)
      @filename = original_filename
      @filetype = 'wav'

      File.open(original_filename, 'rb') do |file|
        begin
          raw_header = file.read(12)

          # A file that's less than 12 bytes long cannot possibly be a wav
          unless raw_header && raw_header.size == 12
            @valid = @content_valid = @type_valid = false
            @error_msg = "File too short"
            return
          end

          riff, filelen, wave = raw_header.unpack('A4VA4')
          if riff != 'RIFF' || wave != 'WAVE'
            @valid = @content_valid = @type_valid = false
            @error_msg = "No RIFF/WAV header found"
            return
          end

          # We found a RIFF/WAVE header, so the type is valid
          @type_valid = true

          # This odd code two lines below actually allows the difference
          # in actual file size and expected file size to differ by 1.
          # Some files add a padding byte if the last chunk is odd length,
          # but don't add this to to the file size in the header, causing
          # this minor inconsistency.
          actual_file_size = File.size(original_filename)
          if (filelen + 8 - actual_file_size).abs > 1
            @valid = @content_valid = false
            @error_msg = "File size error for WAV, header says #{filelen+8}, actual is #{actual_file_size}"
            return
          end

          @chunks = []

          # The fmt chunk is passed in to subsequent chunks as the
          # data chunk will use it to determine some information.
          fmt_chunk = data_chunk = nil

          # Read each chunk
          until file.eof?
            chunk = Chunk.read(file, @chunks)
            if chunk
              @chunks.push chunk
            else
              @valid = @content_valid = false
              @error_msg = "Invalid chunk found"
              return
            end
          end

          # We should have a fmt chunk and a data chunk here
          fmt_chunk = @chunks.detect { |chunk| chunk.chunk_type == 'fmt' }
          data_chunk = @chunks.detect { |chunk| chunk.chunk_type == 'data' }

          unless fmt_chunk && data_chunk
            @valid = @content_valid = false
            @error_msg = "Missing fmt and/or data chunk"
            return
          end

          # Make sure chunk lengths add up.  Each chunk has an 8-byte header,
          # plus the file has a 12 byte header.  Odd sized chunks should be
          # followed by a padding byte, so that is added in at the end.
          # Note: the last chunk won't have a padding byte.
          total_chunk_length = 12 + @chunks.size * 8 + @chunks.map { |ci| ci.length }.inject(0) { |s,n| s+n } + @chunks.select { |ci| ci.length.odd? }.size
          if total_chunk_length == actual_file_size || (total_chunk_length - 1 == actual_file_size && @chunks.last.length.odd?)
            @duration = data_chunk.number_of_sample_frames.to_f / fmt_chunk.sample_rate.to_f
            @valid = @content_valid = true
          else
            @valid = @content_valid = false
            @error_msg = "Total chunk length #{total_chunk_length} is invalid: expected #{actual_file_size}"
          end
        end
      end
    end
  end
end
