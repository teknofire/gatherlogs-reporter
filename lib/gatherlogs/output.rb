require 'paint'

module Gatherlogs
  module Output
    FAILED = '#FF3333'.freeze
    GREEN = PASSED = '#32CD32'.freeze
    SKIPPED = '#BEBEBE'.freeze
    INFO = '#FF8C00'.freeze

    DESC_ICON = 'ⓘ'.freeze
    KB_ICON = '✩'.freeze
    SUMMARY_ICON = '⇨'.freeze

    PASSED_ICON = '✓'.freeze
    FAILED_ICON = '✗'.freeze
    SKIPPED_ICON = '↺'.freeze

    # rubocop:disable Style/ClassVars
    def enable_colors
      @@enable_colors = true
    end

    def disable_colors
      @@enable_colors = false
    end

    def colors_enabled?
      @@enable_colors
    end
    # rubocop:enable Style/ClassVars

    def debug(*msg)
      color = if msg.last[0] == '#'
                msg.pop
              else
                INFO
              end
      msg = colorize(msg.join(' ').chomp, color)

      Gatherlogs.logger.debug(msg)
    end

    def info(*msg)
      color = if msg.last[0] == '#'
                msg.pop
              else
                GREEN
              end
      msg = colorize(msg.join(' ').chomp, color)

      Gatherlogs.logger.info(msg)
    end

    def error(*msg)
      color = if msg.last[0] == '#'
                msg.pop
              else
                FAILED
              end
      msg = colorize(msg.join(' ').chomp, color)
      Gatherlogs.logger.error(msg)
    end

    def colorize(text, color)
      return text if color == :nothing || !colors_enabled?

      Paint[text, color]
    end

    def truncate(text, length = 700)
      text[0..(length - 1)]
    end

    # Make sure that we tab over the output for multiline text so that it lines
    # up with the rest of the output.
    def tabbed_text(text, spaces = 0)
      Array(text).join("\n").gsub("\n", "\n#{' ' * (4 + spaces.to_i)}")
    end

    def labeled_output(label, output, override_colors = {})
      colors = { label: INFO, output: :nothing }.merge(override_colors)

      label_output = colorize(label, colors[:label])

      "#{label_output} #{colorize output, colors[:output]}"
    end

    # Print out detailed info for each test subsection
    # For example the description, summary or kb info provided in the control
    def subsection(output)
      '  ' + output unless output.nil? || output.empty?
    end
  end
end
