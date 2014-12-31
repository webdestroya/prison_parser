module PrisonParser
  class Prison < Node

    def initialize
      super("Prison")
    end

    # Open a prison from the file specified
    #
    # @param filename [String] The path to the +.prison+ file you want to load
    #
    # @return [Prison]
    def self.open(filename)
      file = File.open(filename, "r")
      prison = PrisonParser::Utils::Parser.new.load(file)
      file.close
      return prison
    end

    # Save the prison to the specified filename
    #
    # @param filename [String] The path where you want to write the prison to
    #
    # @return [void]
    def save(filename)
      file = File.open(filename, "w+")
      PrisonParser::Utils::Writer.new(file).write_prison(self)
      file.close
    end

    def create_node(node_label)
      if PrisonParser::Models.const_defined?(node_label)
        node = PrisonParser::Models.const_get(node_label).new
        @nodes[node.label] = node
        node
      else
        super
      end
    end

  end
end
