# Pocketwatch

`pocketwatch` is a clone of the `watch` utility found on many UNIX-based operating systems. It exists entirely due to the fact that `watch` swallows CTRL-code shortcuts that aren't CTRL-C (interrupt), and as a result, makes it really difficult to use CTRL codes to navigate around terminal panes. A Ruby implementation serves the same purpose but doesn't jack up my terminal navigation.

Yes, that's the only reason this exists.

## Installation

```bash
gem install pocketwatch
```

## Usage

```
Usage: pocketwatch [options] -- <command>
    -v, --version                    Print the version number
    -n INTERVAL                      Length in seconds between command execution
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
