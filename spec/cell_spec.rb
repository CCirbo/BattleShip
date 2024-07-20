require "spec_helper"

RSpec.configure do |config| 
 config.formatter = :documentation 
 end

RSpec.describe Cell do 
  before(:each) do 
    @cell = Cell.new("B4")
    @cell_1 = Cell.new("A2")
    @cell_2 = Cell.new("C3")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe '#initalize()' do
    it 'can exist' do
      expect(@cell).to be_a(Cell)
    end

    it 'has a coordinate' do
      expect(@cell.coordinate).to eq("B4")
    end
  end

  describe '#cell status' do
    it "checks if a cell can hold a ship" do
      expect(@cell.ship).to eq(nil)
    end 

    it 'can tell if the cell is empty' do
      expect(@cell.empty?).to eq(true)
    end
  end

  describe '#ships' do
    it 'can place a ship on an empty cell' do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
    end

    it 'can tell if cell is not empty' do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
      expect(@cell.empty?).to eq(false)
    end
  end
  
  describe '#fired_upon?' do
    it 'has fired_upon? assigned false by default' do
      expect(@cell.fired_upon?).to eq(false)
    end
  end

  describe '#fire_upon' do
    it 'will update ship health if ship has been fired upon' do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon).to eq(false)
      @cell.fire_upon
      
      expect(@cell.ship.health).to eq(2)
      expect(@cell.fired_upon).to eq(true)
    end
  end

  describe '#render board()' do
    it 'shows the string "." as default' do
      expect(@cell_1.render).to eq(".")
    end

    it 'changes "." to "M" if fired upon and contains no ships' do
      expect(@cell_1.render).to eq(".")
      @cell_1.fire_upon
      expect(@cell_1.render).to eq("M")
    end

    it 'shows the string "H" if cell has been fired upon and it contains a ship' do
      @cell_1.place_ship(@cruiser)
      @cell_1.fire_upon
      expect(@cell_1.render).to eq("H")
    end

    it 'shows the string "X" if cell has been fired upon and ship has sunk' do
      @cell_1.place_ship(@cruiser)
      @cell_1.fire_upon
      expect(@cell_1.render).to eq("H")
      2.times do
        @cell_1.fire_upon
      end
      expect(@cruiser.sunk?).to eq(true)
      expect(@cell_1.render).to eq("X")
   end
  
    it 'shows ship placement on board when show ship render is true' do
      expect(@cell_2.render).to eq(".")
      @cell_2.place_ship(@cruiser)
      expect(@cell_2.render(true)).to eq("S")
    end

    it 'does not show ship placement on board if show ship render is false' do
      expect(@cell_2.render).to eq(".")
      @cell_2.place_ship(@cruiser)
      expect(@cell_2.render(false)).to eq(".")
    end
  end
end

