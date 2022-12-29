# frozen_string_literal: true

module AudioFileInfo
  class AudioFile
    class AudioFileInfoError < StandardError; end

    attr_reader :filename
    attr_reader :duration
    attr_reader :valid
    attr_reader :content_valid
    attr_reader :type_valid
    attr_reader :error_msg

    class << self
      attr_reader :file_specific_classes
    end

    @file_specific_classes = []

    def open(original_filename)
      @filename = original_filename

      ext = File.extname(original_filename).downcase
      runner = @file_specific_classes.detect { |c| c.can_handle_file?(ext) }
      if runner
        runner.new(original_filename)
      else
        nil
      end
    end

    def self.inherited(subclass)
      AudioFileInfo::AudioFile.file_specific_classes << subclass
    end

    def can_handle_file?(ext)
      false
    end

    def inspect
      "#<#{self.class.name}:#{'0x%x' % (self.object_id)}, filename: #{filename}, duration: #{duration}>"
    end
  end
end
