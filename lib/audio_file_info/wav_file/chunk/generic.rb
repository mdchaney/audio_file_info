# frozen_string_literal: true

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile
    class Chunk
      class Generic < AudioFileInfo::WavFile::Chunk::Base
        def initialize(file, chunk_type, prior_chunks)
          if super(file, chunk_type)
            skip_chunk(file)
          end
        end
      end
    end
  end
end
