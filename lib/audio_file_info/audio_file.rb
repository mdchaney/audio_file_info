# frozen_string_literal: true

module AudioFileInfo
  class AudioFile
    class AudioFileInfoError < StandardError; end

    # These are standard attributes for all file types
    attr_reader :filename
    attr_reader :filetype
    attr_reader :duration
    attr_reader :valid
    attr_reader :content_valid
    attr_reader :type_valid
    attr_reader :error_msg

    alias_method :valid?, :valid
    alias_method :content_valid?, :content_valid
    alias_method :type_valid?, :type_valid

    @file_specific_classes = []

    class << self
      attr_reader :file_specific_classes

      # Add subclasses here so we can keep track of them
      def inherited(subclass)
        AudioFileInfo::AudioFile.file_specific_classes << subclass
        super
      end

      # Main method - find a subclass to handle this file type and
      # hand if off
      def open(original_filename)
        @filename = original_filename

        ext = File.extname(original_filename).downcase
        runner = @file_specific_classes.detect { |c| c.can_handle_file?(ext) }
        runner&.new(original_filename)
      end
    end

    # Will be overridden in subclasses
    def can_handle_file?(ext)
      false
    end

    def inspect
      <<~INSPECT.gsub(/\n/, " ")
        #<#{self.class.name}:#{format("0x%x", object_id)},
        filename: #{filename}, filetype: #{filetype},
        duration: #{duration}, valid: #{valid},
        content_valid: #{content_valid}, type_valid: #{type_valid}>
      INSPECT
    end
  end
end
