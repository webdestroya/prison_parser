require 'tempfile'
require 'digest'
require 'spec_helper'

describe PrisonParser::Utils::Writer do
  let(:parser) { PrisonParser::Utils::Parser.new }
  let(:prison) { parser.load("spec/fixtures/full.prison") }

  describe "#write_prison" do
    it "writes a prison that can be parsed" do
      temp1 = Tempfile.new("prison1.prison")
      temp2 = Tempfile.new("prison2.prison")

      PrisonParser::Utils::Writer.new(temp1).write_prison(prison)
      temp1.close

      prison2 = parser.load(temp1.path)

      PrisonParser::Utils::Writer.new(temp2).write_prison(prison2)
      temp2.close

      expect(Digest::MD5.file(temp1.path)).to eq Digest::MD5.file(temp2.path)

      temp1.unlink
      temp2.unlink
    end
  end

  # describe "#write_node" do
  #   it "handles inlining" do
  #     finance = prison.Objects.nodes["[i 2530]"]
  #     puts finance.nodes.size
  #     puts finance.properties.size
  #     puts PrisonParser::Utils::Writer.new.write_node(finance).stream.string
  #   end
  # end
end
