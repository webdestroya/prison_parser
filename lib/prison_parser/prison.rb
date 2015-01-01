module PrisonParser
  class Prison < Node

    node_class :Finance, PrisonParser::Models::Finance

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
      prison = PrisonParser::Utils::Parser.new.load(file, Prison)
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
      if node_label == "Cells"
        nodes['Cells'] ||= PrisonParser::Models::Cells.new(self.NumCellsX.to_i, self.NumCellsY.to_i)
      else
        super
      end
    end

  end
end
