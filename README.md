# AudioFileInfo

## Please note that this gem is in development and is not ready for use

The AudioFileInfo gem provides basic validity-checking and other
information for four standard audio file formats:

1. WAV
2. AIF
3. MP3
4. Flac

The gem is written in pure Ruby and has no other dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audio_file_info'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install audio_file_info

## Usage

```ruby
require 'audio_file_info'

info = AudioFileInfo.new('filename.mp3')
puts info.valid?
puts info.duration

file = File.open('filename.wav')
info = AudioFileInfo.new(file)
puts info.valid?
puts info.duration
```

Note that audio files must be perfect to be considered "valid" by this
gem.  The most common problems seem to be with files that are truncated
and thus not as long as the various headers would suggest.  Some
software also seems to create invalid WAV files if there is an
odd-length chunk.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/mdchaney/audio_file_info.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
