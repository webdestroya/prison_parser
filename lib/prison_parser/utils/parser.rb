module PrisonParser
  module Utils
    class Parser

      attr_reader :tokens

      def initialize
        @tokens = []
      end

      def load(stream)
        line_num = 0
        nodes = []
        @tokens = []
        currentNode = Prison.new

        while !stream.eof? do
          line = stream.readline.strip
          line_num += 1
          tokenize(line)

          next if tokens.size == 0

          # start a new node
          if "BEGIN" == tokens[0]
            nodes.push(currentNode)

            label = tokens[1]
            currentNode = currentNode.create_node(label)

            if tokens.size > 2
              # inline node
              if tokens.size % 2 != 1
                raise "Unexpected number of tokens in an inline node definition on line #{line_num}"
              end

              unless "END" == tokens[tokens.size - 1]
                raise "Unexpected end of inline node definition on line #{line_num}"
              end

              tokens[2..-2].each_slice(2) do |parts|
                # the first one is bogus :/
                currentNode.add_property(parts[0], parts[1])
              end

              upperNode = nodes.pop
              upperNode.finished_reading_node(currentNode)
              currentNode = upperNode
            else
              currentNode.prevent_inlining!
            end
          elsif "END" == tokens[0]
            # end of multi-line section
            upperNode = nodes.pop
            upperNode.finished_reading_node(currentNode)
            currentNode = upperNode
          else
            # inside a multi-line section
            currentNode.add_property(tokens[0], tokens[1])
          end
        end

        if nodes.size != 0
          raise "Unexpected end of file!"
        end

        currentNode
      end

      # Splits a line into a series of tokens
      def tokenize(line)
        return if line.size == 0

        tokens.clear

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

            end_quotes = -1 if end_quotes.nil?

            tokens << line[i + 1, end_quotes - i - 1]
            i = end_quotes
            token_start = i + 1
          else
            # skip ahead to the next space
            next_space = line.index(' ', i)
            next_space = -1 if next_space.nil?
            i = next_space - 1
            break if (i < 0)
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
