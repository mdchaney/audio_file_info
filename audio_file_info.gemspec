# frozen_string_literal: true

require_relative "lib/audio_file_info/version"

Gem::Specification.new do |spec|
  spec.name = "audio_file_info"
  spec.version = AudioFileInfo::VERSION
  spec.authors = ["Michael Chaney"]
  spec.email = ["mdchaney@michaelchaney.com"]

  spec.summary = "AudioFileInfo provides information about audio files."
  spec.description = "AudiofileInfo is a pure Ruby gem that parses audio files (WAV, AIF, MP3, and Flac) and provides basic information such as duration, as well as validity checking.  It doesn't rely on any other libraries."
  spec.homepage = "https://github.com/mdchaney/audio_file_info"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + '/CHANGELOG'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
