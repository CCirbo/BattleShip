require "spec_helper"

RSpec.configure do |config| 
 config.formatter = :documentation 
 end

 RSpec.describe Cell do 
  before(:each) do 
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initalize()" do
    it "can exist" do
      expect(@cell).to be_a(Cell)
    end

    it "has a coordinate" do
      expect(@cell.coordinate).to eq("B4")
    end

    it 'will be instantiated with a fired_upon attribute set to false' do
      expect(@cell.fired_upon).to eq(false)
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
  
  describe "#fired_upon?" do
    it 'will return state of fired_upon attribute' do
      expect(@cell.fired_upon?).to eq(false)
    end
  end

  describe "#fire_upon" do
    it 'will update the status of fired_upon attribute' do
      expect(@cell.fired_upon).to eq(false)
      @cell.fire_upon

      expect(@cell.fired_upon).to eq(true)
    end
    
    it 'will NOT revert status of fired_upon from true to false' do
      @cell.fire_upon
      expect(@cell.fired_upon).to eq(true)
      @cell.fire_upon

      expect(@cell.fired_upon).not_to eq(false)
    end
    
    it 'will update ship health if cell is occupied' do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon).to eq(false)
      @cell.fire_upon
      
      expect(@cell.ship.health).to eq(2)
      expect(@cell.fired_upon).to eq(true)
    end
  
end

  describe "#render()" do
    it 'will return the string "." if the cell has not been fired upon' do
      #require"pry";binding.pry
      expect(@cell.render).to eq(".")
    end

    it 'will return the string "M" if the cell has been fired upon and it does not contain a ship' do
      @cell.fire_upon

      expect(@cell.render).to eq("M")
    end

    it 'will return the string "H" if the cell has  been fired upon and it contains a ship' do
      @cell.place_ship(@cruiser)
      @cell.fire_upon

      expect(@cell.render).to eq("H")
    end

    it 'will return the string "X" if the cell has been fired upon and its ship has been sunk' do
      @cell.place_ship(@cruiser)
      3.times do
        @cell.fire_upon
      end

      expect(@cell.render).to eq("X")
    end

  end

end
