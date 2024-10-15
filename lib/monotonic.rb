# frozen_string_literal: true

require_relative "monotonic/version"

# Monotonic
ext = case RUBY_PLATFORM
      when /linux/
        "so"
      when /darwin/
        "bundle"
      when /mingw|mswin/
        "dll"
      else
        raise "Unsupported platform: #{RUBY_PLATFORM}"
      end

require_relative File.expand_path("../ext/monotonic.#{ext}", __dir__)
