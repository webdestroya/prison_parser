module PrisonParser
  module Utils
    class Parser

      # Base error type for all parser exceptions
      class ParseError < StandardError; end

      # Throw when there are an odd number of token pairs
      # given on an inline node definition
      class UnevenTokenError < ParseError; end

      # The last token of an inline node must be +END+
      class UnexpectedEndOfLineError < ParseError; end

      # File contains unmatched node definitions
      class UnexpectedEndOfFileError < ParseError; end

      # File contains unmatched quote
      class UnmatchedQuoteError < ParseError; end

      attr_reader :tokens

      def initialize
        @tokens = []
      end

      # Parses the given stream and returns a node tree
      #
      # @param stream [IO] The +IO+ stream to parse from.
      # @param parent_class [Class] The class for the root node.
      def load(stream, root_class = nil)
        root_class ||= PrisonParser::Node
        line_num = 0
        nodes = []
        @tokens = []
        current_node = root_class.new

        while !stream.eof? do
          line = stream.readline.strip
          line_num += 1
          tokenize(line)

          next if tokens.size == 0

          # start a new node
          if "BEGIN" == tokens[0]
            nodes.push(current_node)

            label = tokens[1]
            current_node = current_node.create_node(label)

            if tokens.size > 2
              # inline node
              if tokens.size % 2 != 1
                raise UnevenTokenError.new("Unexpected number of tokens in an inline node definition on line #{line_num}")
              end

              unless "END" == tokens[tokens.size - 1]
                raise UnexpectedEndOfLineError.new("Unexpected end of inline node definition on line #{line_num}")
              end

              # Don't iterate the 'BEGIN', label, 'END'
              tokens[2..-2].each_slice(2) do |parts|
                current_node.add_property(parts[0], parts[1])
              end

              upper_node = nodes.pop
              upper_node.finished_reading_node(current_node)
              current_node = upper_node
            else
              current_node.prevent_inlining!
            end
          elsif "END" == tokens[0]
            # end of multi-line section
            upper_node = nodes.pop
            upper_node.finished_reading_node(current_node)
            current_node = upper_node
          else
            # inside a multi-line section
            current_node.add_property(tokens[0], tokens[1])
          end
        end

        if nodes.size != 0
          raise UnexpectedEndOfFileError.new("Unexpected end of file!")
        end

        current_node
      end

      # Splits a line into a series of tokens
      def tokenize(line)
        tokens.clear

        return if line.size == 0
        line = line.tr("\t", ' ')
        token_start = 0
        i = 0
        chars = line.chars

        while i < line.size do
          c = chars[i]
          if c == ' '
            # eat the spaces!
            if token_start != i
              tokens << line[token_start, i - token_start]
            end
            token_start = i + 1
          elsif c == '"'
            # skip ahead to the next quote
            end_quotes = line.index('"', i + 1)

            raise UnmatchedQuoteError.new("Unmatched quote on '#{line}'") if end_quotes.nil?

            tokens << line[i + 1, end_quotes - i - 1]
            i = end_quotes
            token_start = i + 1
          else
            # skip ahead to the next space
            next_space = line.index(' ', i) || -1
            i = next_space - 1
            break if i < 0
          end
          i += 1
        end

        if token_start < line.size
          # append the remainder of the string, after we ran out of spaces
          tokens << line[token_start, line.size - token_start]
        end

        return tokens
      end
    end
  end
end
