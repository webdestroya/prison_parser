require 'spec_helper'

describe PrisonParser::Materials do
  subject { PrisonParser::Materials }

  describe ".open" do
    it "opens and parses the requested file" do
      materials = PrisonParser::Materials.open("spec/fixtures/materials.txt")
      expect(materials).to be_a PrisonParser::Materials
    end
  end

end
