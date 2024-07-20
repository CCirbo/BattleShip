class Cell 
  attr_reader :coordinate,
              :ship,
              :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil? 
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if @ship != nil
      @ship.hit
    end
    @fired_upon = true
  end
  
  def render(show_ship = false)
    if @fired_upon
      return "M" if empty?
      return "X" if @ship.sunk?
      return "H" if !empty?
    elsif show_ship && !empty?
      "S"
    else
      "."
    end
  end

end