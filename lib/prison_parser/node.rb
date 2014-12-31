module PrisonParser
  class Node
    attr_reader :nodes
    attr_reader :properties
    attr_reader :label

    def initialize(label=nil)
      @label = label
      @nodes = Hash.new
      @properties = Hash.new
      @allow_inline = true
    end

    def allow_inline?
      @allow_inline
    end

    def prevent_inlining!
      @allow_inline = false
    end

    def inspect
      str = StringIO.new("")
      str.write "<#{label} "
      str.write properties.entries.map { |e| "#{e[0]}=#{e[1].inspect}" }.join(", ")
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

    # Equality

    def eql?(other)
      # quick check:
        # make sure property keys are the same
        # make sure node labels are equal

      # Semi deep: compare the properties

      # DEEP:
        # Compare the nodes

      return false unless other.is_a?(Node)

      # Check properties
      return false unless properties.eql?(other.properties)

      # Check node labels
      node_labels = nodes.values.map(&:label).sort
      other_labels = other.nodes.values.map(&:label).sort

      # Quick check to ensure both have the same labels
      return false unless node_labels.eql?(other_labels)

      # Compare all the nodes
      nodes.each_key do |node_key|
        return false unless nodes[node_key].eql?(other.nodes[node_key])
      end

      return true
    end

    alias_method :==, :eql?

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

    # For accessing properties/nodes
    def [](key)
      if properties.has_key?(key)
        properties[key]
      elsif nodes.has_key?(key)
        nodes[key]
      else
        nil
      end
    end


    def method_missing(name, *args, &block)
      # Look in Nodes
      # Look in properties
      # if ends with ?, cast property to boolean
      # else SUPER

      name = name.to_s

      if properties.has_key?(name)
        properties[name]
      elsif nodes.has_key?(name)
        nodes[name]
      else
        super
      end
    end

  end
end
