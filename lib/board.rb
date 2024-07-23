class Board 
  attr_reader :cells

  def initialize
    @cells = populate_board_with_cells
  end

  def populate_board_with_cells
    hash = {}
    ("A".."D").each do |letter|
        (1..4).each do |number|
        coordinate = letter + number.to_s
        hash[coordinate] = Cell.new(coordinate)
       end
    end
    hash
  end

   def valid_coordinate?(coordinate)
      @cells.has_key?(coordinate)
   end

   def valid_placement?(ship, coordinate_array)
      if ship.class == Ship && coordinate_array.class == Array
        valid_coords =  coordinate_array.map do |coord|
        valid_coordinate?(coord)
      end
     return false if valid_coords.include?(false) #needed to validate valid coord first
        valid_length?(ship, coordinate_array) && valid_consecutive?(ship, coordinate_array) && !(overlap?(coordinate_array)) 
      else
        false
      end

#       (ship.class == Ship && coordinate_array.class == Array) ?
#             valid_length?(ship, coordinate_array) && 
#             valid_consecutive?(ship, coordinate_array) &&
#             !(overlap?(coordinate_array)) : false

   end

   def valid_length?(ship, coordinate_array)
      coordinate_array.length == ship.length ? true : false
   end

   def transform_coordinate_array(coordinate_array)
      numeric_coordinates = coordinate_array.map do |cell|
        numeric = []
        mid_output = cell.chars
        numeric << mid_output[0].ord
        numeric << mid_output[1].to_i
       end
   end

   def valid_consecutive?(ship, coordinate_array)
      numeric_coordinates = transform_coordinate_array(coordinate_array)
      return false unless [2, 3].include?(ship.length)
      if ship.length == 2
        (row_consecutive?(numeric_coordinates) || column_consecutive?(numeric_coordinates)) 
      elsif ship.length == 3
        (three_in_a_row?(numeric_coordinates) || three_in_a_column?(numeric_coordinates))
      end
   end

   def row_consecutive?(coordinates)
      coordinates[0][0] == coordinates[1][0] && coordinates[0][1] + 1 == coordinates[1][1]
   end

   def column_consecutive?(coordinates)
       coordinates[0][1] == coordinates[1][1] && coordinates[0][0] + 1 == coordinates[1][0]
   end 

   def three_in_a_row?(coordinates)
      coordinates[0][0] == coordinates[1][0] && coordinates[1][0] == coordinates[2][0] &&
      coordinates[0][1] + 1 == coordinates[1][1] && coordinates[1][1] + 1 == coordinates[2][1]
   end

   def three_in_a_column?(coordinates)
      coordinates[0][1] == coordinates[1][1] && coordinates[1][1] == coordinates[2][1] &&
      coordinates[0][0] + 1 == coordinates[1][0] && coordinates[1][0] + 1 == coordinates[2][0]
   end

   def place_ship(ship, coordinate_array)
       if overlap?(coordinate_array) == false
          coordinate_array.each do |coordinate|
            @cells[coordinate].place_ship(ship)
        end
      end
   end

   def overlap?(coordinate_array)
      coordinate_array.any? do |coordinate|
        @cells[coordinate].ship != nil 
      end
   end

   def render(show_ship = false)
      string_output = "  1 2 3 4 \n"
       ("A".."D").each do |letter|
         string_output += "#{letter} "
            (1..4).each do |number|
               coordinate = "#{letter}#{number}"
               string_output += @cells[coordinate].render(show_ship)
               string_output += " " unless number == 4
            end
         string_output += " \n"
       end
      string_output
   end
end