require "optparse"

require_relative "pocketwatch/watcher"

module Pocketwatch
  # Parse the ARGV input and run the command watcher.
  #
  # @param args [Array<String>] the array of input arguments, typically `ARGV`
  #
  # @return [void]
  def self.start(args)
    options = parse(args)
    Watcher.new(args.join(" "), options).run
  end

  # Parse an argument list for configuration options
  #
  # @param args [Array<String>] the array of input arguments, typically `ARGV`
  #
  # @return [Hash] the options hash
  def self.parse(args)
    options = {}

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: pocketwatch [options] -- <command>"

      opts.on("-v", "--version", "Print the version number") do
        puts Pocketwatch::VERSION
        exit
      end

      opts.on("-n INTERVAL", Integer, "Length in seconds between command execution") do |v|
        unless v.positive?
          warn "Must provide a positive integer for the command execution interval."
          exit
        end

        options[:interval] = v
      end
    end

    parser.parse!(args)

    options
  end
end
