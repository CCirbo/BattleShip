require "spec_helper"

RSpec.configure do |config| 
 config.formatter = :documentation 
 end

 RSpec.describe Cell do 
  before(:each) do 
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initalize" do
    it "can exist" do
      expect(@cell).to be_a(Cell)
    end

    it "has a coordinate" do
      expect(@cell.coordinate).to eq("B4")
    end
  end

  describe "#cell status" do
    it "checks if a cell can hold a ship" do
      expect(@cell.ship).to eq(nil)
    end 

    it "can tell if the cell is empty" do
      expect(@cell.empty?).to eq(true)
    end
  end

  describe "#ships" do
    it "can place a ship on an empty cell" do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
    end

    it "can tell if cell is not empty" do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
      expect(@cell.empty?).to eq(false)
    end
  end
end
