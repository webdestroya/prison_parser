require 'spec_helper'

describe PrisonParser::Node do
  let(:node) { PrisonParser::Node.new("Test") }

  it "#add_property"

  describe "#create_node" do
    it "uses special models when available"
    it "converts to an array if multiple values added"
  end

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
