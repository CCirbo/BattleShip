require 'spec_helper'

RSpec.configure do |config| 
 config.formatter = :documentation 
 end

 RSpec.describe Ship do 
  before(:each) do 
    @cruiser = Ship.new('Cruiser', 3)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@cruiser).to be_a(Ship)
    end

    it 'has attributes' do
      expect(@cruiser.name).to eq('Cruiser')
      expect(@cruiser.length).to eq(3)
    end

    it 'has a health equal to length' do
      expect(@cruiser.health).to eq(3)
    end
  end

  describe '#sunk' do
    it 'can show ship not sunk is false by default' do
      expect(@cruiser.sunk?).to eq(false)
    end

    it 'can show ship hit and sunk' do
      @cruiser.hit
      expect(@cruiser.health).to eq(2)
      expect(@cruiser.sunk?).to be (false)

      @cruiser.hit
      expect(@cruiser.health).to eq(1)
      expect(@cruiser.sunk?).to be (false)

      @cruiser.hit
      expect(@cruiser.health).to eq(0)
      expect(@cruiser.sunk?).to be (true)

      @cruiser.hit
      expect(@cruiser.health).to eq(0)
    end
  end
end