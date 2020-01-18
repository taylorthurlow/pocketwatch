require_relative "screen"

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

      @screen = Screen.new
    end

    # Begin the watcher task, executing the provided command in a loop. The
    # loop will only break when interrupted in the shell.
    #
    # @return [void]
    def run
      @screen.open

      loop do
        color_splits = color_output_splits(`#{@command}`)

        @screen.window.setpos(0, 0)

        @screen.with_curses do |curses|
          color_splits.each do |(ansi_code, string)|
            color_constant = Screen.color_map[ansi_code.to_i]
            curses.attron(curses.color_pair(color_constant) | curses::A_NORMAL) do
              curses.addstr(string.gsub("\\n", ""))
            end
          end
        end

        @screen.window.refresh

        start_sleep_time = Time.now

        loop do
          sleep(0.01) # sleep 1 millisecond
          elapsed_milliseconds = (Time.now - start_sleep_time) * 1000.0
          interval_in_milliseconds = (@options[:interval] || 2) * 1000.0

          char = @screen.window.getch

          @screen.with_curses do |curses|
            curses.setpos(0, 0)
            curses.addstr(char.to_s)
            @screen.window.refresh
          end

          break if elapsed_milliseconds >= interval_in_milliseconds
        end

        sleep(@options[:interval] || 2)
      end
    rescue Errno::EPIPE, SystemExit, Interrupt
      exit 0
    ensure
      @screen&.close
    end

    private

    def color_output_splits(input)
      matcher = %r{(?:\^\[|\\033|\\u001b|\\e){1}\[([\d;]+)?m}

      # Strip away the quotes that get added to the beginning and end, and make
      # sure that all ANSI escape codes that use `[m` instead of `[0m` are
      # converted properly.
      raw_input = input.dump[1..-2]
                       .gsub(%r{(\^\[|\\033|\\u001b|\\e){1}\[m}, "\\1[0m")

      escape_codes = raw_input.scan(matcher)
      splits = raw_input.split(matcher)

      # Because we're relying on the order of these arrays, determine if the
      # first part of the input is an escape code or a real string, so we know
      # how to pair them up
      unless raw_input.start_with?(escape_codes.first.first)
        splits.prepend("0")
      end

      splits.each_slice(2).to_a
    end

    # Clear the terminal screen by writing a control code to the terminal. This
    # avoids having to shell out to run something like `clear`.
    #
    # @return [void]
    def clear_screen
      puts "\e[H\e[2J"
    end
  end
end
