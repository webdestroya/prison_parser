require 'spec_helper'

describe PrisonParser::Node do
  let(:node) { PrisonParser::Node.new("Test") }

  it "#add_property"

  describe "#create_node" do
    it "returns a Node object" do
      new_node = node.create_node("SomeLabel")
      expect(new_node).to be_instance_of(PrisonParser::Node)
      expect(new_node.label).to eq "SomeLabel"
      expect(node.SomeLabel).to be new_node
    end

    it "converts to an array if multiple values added" do
      node.create_node("SomeLabel")
      expect(node.SomeLabel).to be_instance_of(PrisonParser::Node)
      node.create_node("SomeLabel")
      expect(node.SomeLabel).to be_instance_of(Array)
      expect(node.SomeLabel).to all(be_instance_of(PrisonParser::Node))
    end
  end

  it ".node_class"

  it ".node_classes"

  it "#write_nodes"

  it "#write_properties"

  it "#method_missing"

  it "#[]"

  describe "#inspect" do
    it "with String properties" do
      node.add_property("SomeProp", "SomeVal")
      expect(node.inspect).to eq "<Test SomeProp=\"SomeVal\">"
    end

    it "with Boolean properties" do
      node.add_property("SomeProp", true)
      expect(node.inspect).to eq "<Test SomeProp=true>"
    end

    it "with Integer properties" do
      node.add_property("SomeProp", 123)
      expect(node.inspect).to eq "<Test SomeProp=123>"
    end

    it "with Float properties" do
      node.add_property("SomeProp", 1.21)
      expect(node.inspect).to eq "<Test SomeProp=1.21>"
    end

    it "with Array properties" do
      node.add_property("SomeProp", [1,2,3])
      expect(node.inspect).to eq "<Test SomeProp=[1, 2, 3]>"
    end

    it "with multiple properties" do
      node.add_property("SomeProp", "SomeVal")
      node.add_property("AnotherProp", "AnotherVal")
      expect(node.inspect).to eq "<Test SomeProp=\"SomeVal\", AnotherProp=\"AnotherVal\">"
    end
  end

  describe "inline vs block" do
    it "#allow_inline?" do
      node.instance_variable_set(:@allow_inline, true)
      expect(node).to be_allow_inline

      node.instance_variable_set(:@allow_inline, false)
      expect(node).to_not be_allow_inline
    end

    it "#prevent_inlining!" do
      node.instance_variable_set(:@allow_inline, true)
      node.prevent_inlining!
      expect(node).to_not be_allow_inline
    end
  end

  it "#eql?"
end
