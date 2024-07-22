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
            valid_length?(ship, coordinate_array) && valid_consecutive?(ship, coordinate_array) && !(overlap?(coordinate_array))
            #return false if no_overlap?(coordinate_array)
        else
            false
        end
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
        if ship.length == 2
            if numeric_coordinates[0][0] == numeric_coordinates [1][0] # row
                numeric_coordinates[0][1] + 1 == numeric_coordinates[1][1] ? true : false
            elsif numeric_coordinates[0][1] == numeric_coordinates [1][1] #column
                numeric_coordinates[0][0] + 1 == numeric_coordinates[1][0] ? true : false
            else 
                false
            end
        else #ship.length == 3
            if numeric_coordinates[0][0] == numeric_coordinates [1][0] && numeric_coordinates [1][0] == numeric_coordinates [2][0] #row
                numeric_coordinates[0][1] + 1 == numeric_coordinates[1][1] && numeric_coordinates[1][1] + 1 == numeric_coordinates[2][1] ? true : false
            elsif numeric_coordinates[0][1] == numeric_coordinates [1][1] && numeric_coordinates [1][1] == numeric_coordinates [2][1] #column
                numeric_coordinates[0][0] + 1 == numeric_coordinates[1][0] && numeric_coordinates[1][0] + 1 == numeric_coordinates [2][0] ? true : false
            else 
                false
            end
        end
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
            @cells[coordinate].ship != nil # ship attr is occupied 
        end
    end

    def render(show_ship = false)
        @cells.values.each do |cell|

        end
    end
end