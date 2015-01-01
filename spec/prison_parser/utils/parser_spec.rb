require 'spec_helper'

describe PrisonParser::Utils::Parser do
  let(:parser) { PrisonParser::Utils::Parser.new }

  describe "#load" do

    context "loads various prisons" do
      it "loads deathrow prison" do
        prison = parser.load(File.open("spec/fixtures/deathrow.prison"), PrisonParser::Prison)
        expect(prison.NumCellsX).to eq "110"
        expect(prison.NumCellsY).to eq "80"
      end

      it "loads full prison" do
        prison = parser.load(File.open("spec/fixtures/full.prison"), PrisonParser::Prison)
      end
    end

    context "only adds valid properties" do
      let(:prop_test_str) do
        <<-PROPTEST
        Thing yar
        BEGIN Stuff
          Another thing
          Another thing
        END
        BEGIN InlineProps Something 1  Blah yar  Hah 1.2 END
        PROPTEST
      end
      let(:stream) { StringIO.new(prop_test_str) }

      it "does not add BEGIN or END as properties" do
        prison = parser.load(stream)

        expect(prison.InlineProps.Something).to eq "1"
        expect(prison.InlineProps.Blah).to eq "yar"
        expect(prison.InlineProps.Hah).to eq "1.2"

        expect(prison.InlineProps.properties.keys.sort).to eq %w(Blah Hah Something)

      end
    end
  end

  describe "#tokenize" do
    it { expect(parser.tokenize("This is a test")).to eq %w(This is a test) }
    it { expect(parser.tokenize(" This is a test")).to eq %w(This is a test) }
    it { expect(parser.tokenize(" This is a test ")).to eq %w(This is a test) }
    it { expect(parser.tokenize("This is a test ")).to eq %w(This is a test) }
    it { expect(parser.tokenize("This \"is a\" test")).to eq ["This", "is a", "test"] }
  end
end
