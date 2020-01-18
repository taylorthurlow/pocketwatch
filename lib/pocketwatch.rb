require "optparse"

require_relative "pocketwatch/watcher"

module Pocketwatch
  def self.start(args)
    options = parse(args)
    Watcher.new(args.join(" "), options).run
  end

  def self.parse(args)
    options = {}

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: pocketwatch [options] -- <command>"

      opts.on("-v", "--version", "Print the version number") do
        puts Pocketwatch::VERSION
        exit
      end

      opts.on("-n INTERVAL", Integer, "Interval length in seconds between command execution") do |v|
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
