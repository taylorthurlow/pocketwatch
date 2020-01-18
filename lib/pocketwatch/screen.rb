require "curses"

module Pocketwatch
  class Screen
    include Curses

    # @return [Boolean] whether or not ANSI color parsing is enabled
    attr_reader :ansi_color

    # @param ansi_color [Boolean] whether or not ANSI color parsing is enabled
    def initialize(ansi_color: false)
      @ansi_color = ansi_color
    end

    # @return [Curses::Window]
    def window
      Curses.stdscr
    end

    def with_curses
      yield Curses
    end

    # @return [void]
    def open
      init_screen # Initialize curses
      init_color  # Set up colors if configured to do so
      noecho      # Disable writing key presses to screen
      cbreak      # Don't wait for carriage return to process input
      nonl        # Prevent the return key from printing a newline
      window.nodelay = false     # Make `getch` non-blocking
      curs_set(0) # Make cursor invisible
    end

    # @return [void]
    def close
      Curses.close_screen
    end

    def self.color_map
      {
        0 => COLOR_BLACK,
        30 => -1,
        31 => COLOR_RED,
        32 => COLOR_GREEN,
        33 => COLOR_YELLOW,
        34 => COLOR_BLUE,
        35 => COLOR_MAGENTA,
        36 => COLOR_CYAN,
        37 => COLOR_WHITE,
      }
    end

    private

    def init_color
      start_color # Allow parsing of color
      use_default_colors # Use default terminal colors
      set_up_color_pairs
    end

    def set_up_color_pairs
      Screen.color_map.values.each do |color_constant|
        init_pair(color_constant, color_constant, -1)
      end
    end
  end
end
