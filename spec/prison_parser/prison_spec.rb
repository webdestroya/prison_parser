require 'spec_helper'

describe PrisonParser::Prison do
  subject { PrisonParser::Prison }

  describe ".open" do
    it "opens and parses the requested file" do
      prison = PrisonParser::Prison.open("spec/fixtures/deathrow.prison")
      expect(prison).to be_a PrisonParser::Prison
      expect(prison.NumCellsX).to eq "110"
    end
  end

  describe "specialized nodes" do

    it "uses special models when available" do
      prison = subject.new

      expect(prison.create_node("Thing")).to be_instance_of(PrisonParser::Node)
      expect(prison.create_node("Finance")).to be_instance_of(PrisonParser::Models::Finance)
    end
  end

  describe "#save" do
    let!(:prison) { PrisonParser::Prison.open("spec/fixtures/deathrow.prison") }

    it "properly calls the writer" do
      temp_prison = Tempfile.new("test_save.prison")

      writer_dbl = double(PrisonParser::Utils::Writer)

      expect(PrisonParser::Utils::Writer).to receive(:new).with(instance_of(File)).and_return(writer_dbl)
      expect(writer_dbl).to receive(:write_prison).with(prison)

      prison.save(temp_prison.path)

      expect(File.exist?(temp_prison.path)).to be_truthy
    end

    it "a proper prison file is created" do
      temp_prison = Tempfile.new("test_save.prison")
      prison.save(temp_prison.path)

      prison2 = PrisonParser::Prison.open(temp_prison.path)

      expect(prison.NumCellsX).to eq prison2.NumCellsX
      expect(prison).to eq prison2
    end
  end

  it "#create_node"
end
