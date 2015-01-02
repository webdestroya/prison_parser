require 'spec_helper'

describe PrisonParser::Models::Cells do

  it "#initialize"

  it "#[]"

  it "#<<"

  it "#each" do
    # Ensure they are iterated in order (x0, y0-yn), (x1,y0-yn) ..
    prison = PrisonParser::Prison.open("spec/fixtures/planned.prison")
    cell_array = []

    prison.Cells.each do |cell|
      cell_array << cell
    end

    expect(cell_array.size).to eq (prison.NumCellsX.to_i * prison.NumCellsY.to_i)

  end

  it "#create_node"
end
