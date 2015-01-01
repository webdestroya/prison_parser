require 'spec_helper'

describe PrisonParser::Models::Cell do

  describe "proper parsing" do
    let(:cell_test_str) do
      <<-CELLTEST
      NumCellsX 10
      NumCellsY 10
      BEGIN Cells
        BEGIN "0 0"     Mat Sand  Con 0.0000 END
        BEGIN "1 0"     Mat Sand  Con 0.0000 END
        BEGIN "2 0"     Con 0.00000  END
        BEGIN "3 0"     Mat MetalFloor  Con 63.6195  Ind true  Room.i 385  Room.u 11623661  END
        BEGIN "4 0"     Mat ConcreteWall  Con 78.1147  Ind true  END
        BEGIN "5 0"     Con 63.6195 Room.i 385  Room.u 11623661  END
        BEGIN "6 0"     Mat ConcreteWall  END
        BEGIN "7 0"     Mat BrickWall  Ind true  END
      END
      CELLTEST
    end
    let(:cell_test_stream) { StringIO.new(cell_test_str) }
    let(:prison) { PrisonParser::Utils::Parser.new.load(cell_test_stream, PrisonParser::Prison) }

    it "#location" do
      cell = prison.Cells[1,0]
      expect(cell.x).to eq 1
      expect(cell.y).to eq 0
    end

    context "#material" do
      it { expect(prison.Cells[0,0].material).to eq "Sand" }
      it { expect(prison.Cells[2,0].material).to be_nil }
    end

    context "#condition" do
      it { expect(prison.Cells[0,0].condition).to eq 0.0 }
      it { expect(prison.Cells[4,0].condition).to eq 78.1147 }
      it { expect(prison.Cells[6,0].condition).to be_nil }
    end

    context "#indoors?" do
      it { expect(prison.Cells[0,0]).to_not be_indoors }
      it { expect(prison.Cells[3,0]).to be_indoors }
    end

    context "#room_id" do
      it { expect(prison.Cells[0,0].room_id).to be_nil }
      it { expect(prison.Cells[3,0].room_id).to eq 385 }
    end

    context "#room_uid" do
      it { expect(prison.Cells[0,0].room_uid).to be_nil }
      it { expect(prison.Cells[3,0].room_uid).to eq 11623661 }
    end

    it "#room"

  end

  it "#initialize" do
    cell = PrisonParser::Models::Cell.new(1,5)
    expect(cell.label).to eq "1 5"
    expect(cell.x).to eq 1
    expect(cell.y).to eq 5
  end
end
