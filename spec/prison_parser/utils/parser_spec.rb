require 'spec_helper'

describe PrisonParser::Utils::Parser do
  let(:parser) { PrisonParser::Utils::Parser.new }

  describe "#load" do
    it "loads deathrow prison" do
      prison = parser.load("spec/fixtures/deathrow.prison")
      skip "TODO"
    end

    it "loads full prison" do
      prison = parser.load("spec/fixtures/full.prison")
      skip "TODO"
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
