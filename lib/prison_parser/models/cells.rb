module PrisonParser
  module Models
    class Cells < Base

      def initialize(width=100, height=100)
        @cells = (0...width).map { Array.new(height) }
        super("Cells")
      end

      def [](x,y)
        @cells[x][y]
      end

      def push(cell)
        @cells[cell.x][cell.y] = cell
      end
      alias_method :<<, :push

      def each
        @cells.flatten.compact.each do |cell|
          yield(cell)
        end
      end

      def create_node(label)
        x, y = label.split.map(&:to_i)
        push Cell.new(x, y)
      end

    end
  end
end
