# frozen_string_literal: true

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile
    class Chunk
      class Fmt < AudioFileInfo::WavFile::Chunk::Base
        attr_reader :format_tag, :number_of_channels, :sample_rate
        attr_reader :average_bytes_per_second, :block_align
        attr_reader :bits_per_sample, :extended_size, :valid_bits_per_sample
        attr_reader :channel_mask, :subformat
        attr_reader :has_exntension, :bytes_per_sample

        def initialize(file, chunk_type, prior_chunks)
          if super(file, chunk_type)
            chunk_content = read_chunk(file)

            # Expand it out to 40 characters
            chunk_content += (0.chr * (40 - chunk_content.size))

            @format_tag, @number_of_channels, @sample_rate,
            @average_bytes_per_second, @block_align,
            @bits_per_sample, @extended_size, @valid_bits_per_sample,
            @channel_mask, @subformat =
              chunk_content.unpack("v v V V v v v v V a16")

            # In this case, the format tag is the first two bytes of
            # the subformat
            if @extended_size == 22 && @format_tag == 65534
              @format_tag = @subformat.unpack("v").first
            end

            @bytes_per_sample = @bits_per_sample / 8
          end
        end
      end
    end
  end
end
