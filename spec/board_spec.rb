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

    it 'can validate coordinate' do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
  end

  it 'can check if the number of coordinates in the array are the same as the length of the ship' do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A2", "A3"])).to eq(true)
end

  it 'can check if there is a valid horizontal placement' do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to eq(true)
    expect(@board.valid_placement?(@cruiser, ["A1", "C1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser, ["C1", "B1"])).to eq(false)
  end

  it 'can check if there is a valid vertical placement' do
    expect(@board.valid_placement?(@cruiser, ["A1", "B1", "C1"])).to eq(true)
    expect(@board.valid_placement?(@cruiser, ["A3", "B2", "C3"])).to eq(false)

  end
  
  it 'can check that diagonal placement is not valid' do
    expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to eq(false)
  end


  it 'can check if the coordinates are consecutive' do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser,["A3", "A2", "A1"])).to eq(false)
    expect(@board.valid_placement?(@cruiser,["A1", "A2", "A3"])).to eq(true)
    expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to eq(false)
    expect(@board.valid_placement?(@submarine, ["B1", "C1"])).to eq(true)
  end

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
  pry(main)> board.valid_placement?(submarine, ["A1", "A2"])
  # => true

  pry(main)> board.valid_placement?(cruiser, ["B1", "C1", "D1"])
  # => true
end
