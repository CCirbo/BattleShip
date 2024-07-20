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
end