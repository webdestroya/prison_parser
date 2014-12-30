module PrisonParser
  module Utils
    class Writer
      INDENT_STR = "    "

      attr_reader :stream
      

      def initialize(stream=nil)
        @stream = stream || StringIO.new("")
        @inline = false
        @inline_stack = []
        @indent = 0
      end

      def write_prison(prison)
        write "\n"
        write_node_data(prison)
        self
      end
      
      def write_node(node)
        return nil if node.nil?
        @inline_stack.push(@inline)
        @inline = node_inline?(node)

        write_indent
        @indent += 1
        write "BEGIN "
        write_value node.label

        if @inline
          write "  "
        else
          write "\n"
        end

        write_node_data(node)

        @indent -= 1

        write_indent unless @inline
        write "END\n"

        @inline = @inline_stack.pop

        self
      end

      def write_indent(indent = nil)
        indent ||= @indent
        return if indent <= 0
        write INDENT_STR*indent
      end

      def write_property(key, value)
        return if value.nil?

        write_indent unless @inline

        write_value key
        write " "
        write_value value

        write (@inline ? "  " : "\n")

      end

      def write_node_data(node)
        node.write_properties(self)
        node.write_nodes(self)
      end

      def write_value(value)
        if quote?(value)
          write "\"#{value}\""
        else
          write value
        end
      end

      def node_inline?(node)
        node.nodes.size == 0 && node.properties.size < 13 && node.allow_inline?
      end

      def quote?(value)
        !value.index(' ').nil?
      end

      def write(data)
        stream.write data
      end

    end
  end
end