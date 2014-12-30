module PrisonParser
  class Prison < Node

    def initialize
      super("Prison")
    end

    # Open a prison from the file specified
    def self.open(filename)
      PrisonParser::Utils::Parser.new.load(filename)
    end

    # Save the prison to the specified filename
    def save(filename)
      file = File.open(filename, "w+")
      PrisonParser::Utils::Writer.new(file).write_prison(self)
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