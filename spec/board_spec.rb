require 'spec_helper'
RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe '#initialize' do
    it 'can exist' do
      expect(@board).to be_an_instance_of(Board)
    end

    it 'can have attributes' do
      expect(@board.cells).to be_an_instance_of(Hash)
      expect(@board.cells.length).to eq(16)
      expect(@board.cells["A1"]).to be_an_instance_of(Cell)
      expect(@board.cells["D4"]).to be_an_instance_of(Cell)
    end
  end

  describe '#valid_coordinate?()' do
    it 'can validate coordinate' do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end

  describe '#valid_placement?()' do 
    it 'requires ship and placement array as arguments' do
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to eq (true)
      expect(@board.valid_placement?("WRONG ARG", 1738)).to eq (false)
    end

    it 'can check if there is a valid horizontal placement' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "D7"])).to eq(false)
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "B3"])).to eq(false)
    end

    it 'can check if there is a valid vertical placement' do
      expect(@board.valid_placement?(@cruiser, ["A1", "B1", "C1"])).to eq(true)
      expect(@board.valid_placement?(@cruiser, ["A3", "B2", "C3"])).to eq(false)
    end
  end

  describe '#valid_length?()' do
    it 'check the number of coordinates in array are the same as the length of ship' do
      expect(@board.valid_length?(@cruiser, ["A1", "A2"])).to eq(false)
      expect(@board.valid_length?(@submarine, ["A2", "A3", "A4"])).to eq(false)
      expect(@board.valid_length?(@submarine, ["A2", "A3"])).to eq(true)
    end
  end

  describe '#transform_coordinate_array()' do
    it 'returns a the argument with values converted to ordinal values' do
      expect(@board.transform_coordinate_array(["A1", "A2", "A3"])). to eq ([[65, 1], [65, 2], [65, 3]])
    end
  end

  describe '#valid_consecutive?()' do 
    it 'can check that diagonal placement is not valid' do
      expect(@board.valid_consecutive?(@cruiser, ["A1", "B2", "C3"])).to eq(false)
      expect(@board.valid_consecutive?(@submarine, ["C2", "D3"])).to eq(false)
    end

    it 'can check if the coordinates are consecutive' do
      expect(@board.valid_consecutive?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
      expect(@board.valid_consecutive?(@cruiser, ["A1", "A2", "A3"])).to eq(true)
      expect(@board.valid_consecutive?(@submarine, ["A1", "A3"])).to eq(false)
      expect(@board.valid_consecutive?(@submarine, ["A1", "A2"])).to eq(true)
      expect(@board.valid_consecutive?(@cruiser, ["A1", "B1", "C4"])).to eq(false)
      expect(@board.valid_consecutive?(@cruiser, ["A1", "B1", "C1"])).to eq(true)
      expect(@board.valid_consecutive?(@submarine, ["A1", "C1"])).to eq(false)
      expect(@board.valid_consecutive?(@submarine, ["A1", "B1"])).to eq(true)
      expect(@board.valid_consecutive?(@cruiser,["A3", "A2", "A1"])).to eq(false)
      expect(@board.valid_consecutive?(@cruiser,["A1", "A2", "A3"])).to eq(true)
      expect(@board.valid_consecutive?(@submarine, ["C1", "B1"])).to eq(false)
      expect(@board.valid_consecutive?(@submarine, ["B1", "C1"])).to eq(true)
    end
  end

  describe '#row_consecutive?()' do
    it 'can check if there is a valid horizontal placement for submarine type' do
      expect(@board.row_consecutive?([[65, 1], [65, 2]])).to eq(true)
      expect(@board.row_consecutive?([[65, 1], [65, 3]])).to eq(false)
      expect(@board.row_consecutive?([[66, 3], [66, 2]])).to eq(false)
    end
  end

  describe '#column_consecutive?()' do
    it 'can check if there is a valid verticle placement for submarine type' do 
      expect(@board.column_consecutive?([[65, 1], [66, 1]])).to eq(true)
      expect(@board.column_consecutive?([[65, 1], [67, 1]])).to eq(false)
      expect(@board.column_consecutive?([[67, 1], [66, 1]])).to eq(false)

    end
  end

  describe '#three_in_a_row?()' do
    it 'can check if there is a valid horizontal placement for cruiser type' do 
      expect(@board.three_in_a_row?([[65, 1], [65, 2], [65, 3]])).to eq(true)
      expect(@board.three_in_a_row?([[65, 3], [65, 2], [65, 1]])).to eq(false)
    end
  end

  describe '#Three_in_a_column?()' do
    it 'can check if there is a valid verticle placement for cruiser type' do 
      expect(@board.three_in_a_column?([[65, 1], [66, 1], [67, 1]])).to eq(true)
      expect(@board.three_in_a_column?([[65, 1], [66, 1], [67, 3]])).to eq(false)
    end
  end

  describe '#place_ship()' do 
   it 'can place a ship on the board' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      expect(@board.cells["A1"].ship).to eq(@cruiser)
      expect(@board.cells["A2"].ship).to eq(@cruiser)
      expect(@board.cells["A3"].ship).to eq(@cruiser)
    end

    it 'can check if ships are overlapping' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      @board.place_ship(@submarine, ["A1", "B1"])
      expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to be false
    end
  end

  describe '#render' do  
   it 'can render the board as a string representation of itself' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      expect(@board.render).to eq( "  1 2 3 4 \n" +
                                  "A . . . . \n" +
                                  "B . . . . \n" +
                                  "C . . . . \n" +
                                  "D . . . . \n")
    end

   it 'can render the board so that it shows ships' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      expect(@board.render(true)).to eq("  1 2 3 4 \n" +
                                        "A S S S . \n" +
                                        "B . . . . \n" +
                                        "C . . . . \n" +
                                        "D . . . . \n")                 
    end 

   it 'can show if board has misses and hits' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      @board.cells["A1"].fire_upon
      @board.cells["B4"].fire_upon
      expect(@board.render).to eq("  1 2 3 4 \n" +
                                  "A H . . . \n" +
                                  "B . . . M \n" +
                                  "C . . . . \n" +
                                  "D . . . . \n")
    end 

   it 'can show sunk ships' do
      @board.place_ship(@submarine, ["C1", "D1"])
      @board.cells["C1"].fire_upon
      @board.cells["D1"].fire_upon
      expect(@board.render).to eq("  1 2 3 4 \n" +
                                  "A . . . . \n" +
                                  "B . . . . \n" +
                                  "C X . . . \n" +
                                  "D X . . . \n")
    end

   it 'can show ships place, hits and misses and sunk ships altogether' do
      @board.place_ship(@cruiser, ["A1", "A2", "A3"])
      @board.cells["A1"].fire_upon
      @board.cells["B4"].fire_upon
      @board.place_ship(@submarine, ["C1", "D1"])
      @board.cells["C1"].fire_upon
      @board.cells["D1"].fire_upon
      expect(@board.render(true)).to eq("  1 2 3 4 \n" +
                                          "A H S S . \n" +
                                          "B . . . M \n" +
                                          "C X . . . \n" +
                                          "D X . . . \n")  
    end
  end
end
