# frozen_string_literal: true

require_relative 'chunk/base'
require_relative 'chunk/generic'
require_relative 'chunk/fmt'
require_relative 'chunk/data'

module AudioFileInfo
  class WavFile < AudioFileInfo::AudioFile
    class Chunk
      def self.read(file, prior_chunks)
        Base.chunk_for(file, prior_chunks)
      end
    end
  end
end
