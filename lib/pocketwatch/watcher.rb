module Pocketwatch
  class Watcher
    # @return [String] the command to run on an interval
    attr_reader :command

    # @return [Hash] the options hash determined by the command-line option
    #   parser
    attr_reader :options

    # @param [String] the command to run on an interval
    # @param [Hash] the options hash determined by the command-line option
    #   parser
    def initialize(command, options = {})
      @command = command
      @options = options
    end

    def run
      loop do
        output = `#{@command}`
        puts "\e[H\e[2J" # clear the screen
        puts output
        sleep @options[:interval] || 2
      end
    rescue Errno::EPIPE, SystemExit, Interrupt
      exit 0
    end
  end
end
