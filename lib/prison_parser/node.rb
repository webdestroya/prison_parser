module PrisonParser
  class Node
    attr_reader :nodes
    attr_reader :properties
    attr_reader :label

    attr_accessor :allow_inline

    def initialize(label=nil)
      @label = label
      @nodes = Hash.new
      @properties = Hash.new
      @allow_inline = true
    end

    def method_missing(name, *args, &block)
      # Look in Nodes
      # Look in properties
      # if ends with ?, cast property to boolean
      # else SUPER      

      if nodes.has_key?(name.to_s)
        nodes[name.to_s]
      elsif properties.has_key?(name.to_s)
        properties[name.to_s]
      else
        super
      end
    end

    def allow_inline?
      @allow_inline
    end

    def inspect
      str = StringIO.new("")
      str.write "<#{label} "
      str.write properties.entries.map { |e|"#{e[0]}=\"#{e[1]}\"" }.join(", ")
      str.write ">"
      str.string
    end

    # ReadKey, PushProperty
    def add_property(key, value)
      return if key == "BEGIN" || key == "END"
      if properties[key]
        if properties[key].is_a?(Array)
          @properties[key] << value
        else
          @properties[key] = [properties[key], value]
        end
      else
        @properties[key] = value
      end
    end

    def create_node(node_label)
      node = Node.new(node_label)
      if nodes.has_key?(node_label)
        if nodes[node_label].is_a?(Array)
          @nodes[node_label] << node
        else
          @nodes[node_label] = [nodes[node_label], node]
        end
      else
        @nodes[node_label] = node
      end
      node
    end

    def finished_reading_node(node)
      # do nothing
    end


    # WRITING

    def write_nodes(writer)
      nodes.values.each do |node|
        if node.is_a?(Array)
          node.map { |n| writer.write_node(n) }
        else
          writer.write_node(node)
        end
      end
    end

    def write_properties(writer)
      properties.each_pair do |k,value|
        if value.is_a?(Array)
          value.map { |v| writer.write_property(k, v) }
        else
          writer.write_property(k, value)
        end
      end
    end

  end
end