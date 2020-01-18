module Pocketwatch
  class Watcher
    # @return [String] the command to run on an interval
    attr_reader :command

    # @return [Hash] the options hash determined by the command-line option
    #   parser
    attr_reader :options

    # @param command [String] the command to run on an interval
    # @param options [Hash] the options hash determined by the command-line
    #   option parser
    def initialize(command, options = {})
      @command = command

      if @command.nil? || @command.empty?
        warn "No command provided."
        exit 1
      end
      @options = options
    end

    # Begin the watcher task, executing the provided command in a loop. The
    # loop will only break when interrupted in the shell.
    #
    # @return [void]
    def run
      loop do
        # Double buffer the output by precomputing the results of the system
        # call. Then, clear the terminal and print the results as quickly as
        # possible - this should avoid any flickering due to clearing the
        # terminal. Restrict the output of the command to the current height of
        # the terminal - scrolling is not supported, and we want to see the
        # first part of the output, not the last.
        num_lines = `tput lines`.strip.to_i - 1
        num_lines = 1 unless num_lines.positive?
        output = `#{@command}`.split("\n").first(num_lines)

        clear_screen
        puts output

        sleep(@options[:interval] || 2)
      end
    rescue Errno::EPIPE, SystemExit, Interrupt
      clear_screen
      exit 0
    end

    private

    # Clear the terminal screen by writing a control code to the terminal. This
    # avoids having to shell out to run something like `clear`.
    #
    # @return [void]
    def clear_screen
      puts "\e[H\e[2J"
    end
  end
end
