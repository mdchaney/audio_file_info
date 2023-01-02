# frozen_string_literal: true

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile
    class Chunk
      class Data < AudioFileInfo::WavFile::Chunk::Base
        attr_reader :number_of_sample_frames

        def initialize(file, chunk_type, prior_chunks)
          if super(file, chunk_type)
            skip_chunk(file)

            # Use information from the format chunk to get our
            # number of sample frames.
            fmt_chunk = prior_chunks.detect do |chunk|
              chunk.chunk_type == "fmt"
            end
            if fmt_chunk
              @number_of_sample_frames = length /
                (fmt_chunk.bytes_per_sample * fmt_chunk.number_of_channels)
            else
              # A format chunk must precede the data chunk
              @valid = false
            end
          end
        end
      end
    end
  end
end
