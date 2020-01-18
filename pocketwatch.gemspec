lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/pocketwatch/version"

Gem::Specification.new do |spec|
  spec.name = "pocketwatch"
  spec.version = Pocketwatch::VERSION
  spec.authors = ["Taylor Thurlow"]
  spec.email = ["taylorthurlow@me.com"]

  spec.summary = "A clone of UNIX 'watch'."
  spec.homepage = "https://github.com/taylorthurlow/pocketwatch"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/taylorthurlow/pocketwatch/releases"

  spec.files = `git ls-files`.split
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "curses"

  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rufo"
  spec.add_development_dependency "solargraph"
end
