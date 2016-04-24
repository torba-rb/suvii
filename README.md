# Suvii

[![Build Status](https://img.shields.io/travis/torba-rb/suvii.svg)](https://travis-ci.org/torba-rb/suvii)
[![Gem version](https://img.shields.io/gem/v/suvii.svg)](https://rubygems.org/gems/suvii)

**Suvii** is a library that abstracts content reading from a remote tar.gz/zip archive. It fetches
the archive and extracts it to a temp directory.

## Name origin

"Сувій" [[suʋii̯][suvii-pronounce]] in Ukrainian can mean a scroll, something which is rolled up or
even a package.

## Status

Production ready.

## Documentation

[Released version](http://rubydoc.info/gems/suvii/0.1.0)


## Installation

Add this line to your application's Gemfile and run `bundle`:

```ruby
gem 'suvii'
```

## Usage

```ruby
temp_directory = Suvii.fetch("https://registry.npmjs.org/coffee-script/-/coffee-script-2.0.0.tgz")
# do whatever you need with extracted content
Dir.glob("#{temp_directory}/**/*").each do |entry|
  # ...
end
```

Note, that fetching same URL twice will unpack to another temp directory. Such design decision was
based on assumption, that generally you don't need everything in an archive, or even have to modify
something. This extra copy/modify step should be totally independent from extraction, and you shouldn't
worry about cleanup, or that another process could mess things up.

## Origin

Extracted from [Torba][torba-github] library since it looks more like a standalone component.

[suvii-pronounce]: https://commons.wikimedia.org/wiki/File:Uk-%D1%81%D1%83%D0%B2%D1%96%D0%B9.ogg
[torba-github]: https://github.com/torba-rb/torba
