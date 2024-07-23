require './lib/ship'
require './lib/cell'
require './lib/board'

class Game
  def initialize
    @player_name = nil
    @name_asked = false
    main_loop
  end

  def setup_game
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @player_cruiser = Ship.new("Cruiser", 3)
    @player_submarine = Ship.new("Submarine", 2)
    @computer_board = Board.new
    @player_board = Board.new
  end

  def main_loop
    loop do
      display_main_menu
      choice = gets.chomp.downcase
      case choice
      when 'yes'
          run_game
      when 'no'
          puts "Exiting game #{@player_name}. Goodbye!"
          exit 
      else
          puts "Invalid please enter 'yes' to play or 'no' to quit."
      end
    end
  end

  def display_main_menu
    unless @name_asked
      puts "\n Please enter your name \n\n"

 

      @player_name = gets.chomp.capitalize

      @name_asked = true
    end
      puts "\nGreetings, #{@player_name}, Welcome to BATTLESHIP \n "
      puts "My name is Joshua, shall we play a game? \n\n"
      puts "Enter 'yes' to play or 'no' to quit."
  end
   
  def run_game
      setup_game
      computer_ship_placement(@computer_cruiser)
      computer_ship_placement(@computer_submarine)
      player_ship_placement_prompt
      player_ship_placement(@player_cruiser, 0)
      player_ship_placement(@player_submarine, 1)
      play_game
  end
 
  def computer_ship_placement(ship)
      random_coords = @computer_board.cells.keys.sample(ship.length)
      until @computer_board.valid_placement?(ship, random_coords)
          random_coords = @computer_board.cells.keys.sample(ship.length) 
      end
          @computer_board.place_ship(ship, random_coords)     
  end
  
  def player_ship_placement_prompt
      puts "I have laid out my ships on the grid. \n "
      puts "You now need to lay out your two ships. \n "
      puts "The Cruiser is three units long and the Submarine is two units long. \n "
  end
  
  def player_ship_placement(ship, show)
    example = nil
    if ship.length == 3
        example = "(ie. A1, A2, A3)"
    else 
        example = "(ie. A1, A2)"
    end
      show == 0 ? (puts @player_board.render) : (puts @player_board.render(true))

          puts " \n Enter the squares for the #{ship.name} (#{ship.length} spaces #{example}): \n "
      

       
          user_input = gets.chomp.upcase.gsub(",", " ").split

      until @player_board.valid_placement?(ship, user_input)
          puts "Invalid placement. Must be consecutive and not diagonal"
          user_input = gets.chomp.upcase.gsub(",", " ").split
      end
      @player_board.place_ship(ship, user_input)
      puts " \n Your #{ship.name} has been placed. \n "
  end

  def turn_start
      puts "==========COMPUTER BOARD========= \n "
      puts @computer_board.render
      puts " \n ==========PLAYER BOARD=========== \n "
      puts @player_board.render(true)
  end
  
  def player_turn_shot

        puts " \n Enter the coordinate for your shot: \n "
            user_input = gets.chomp.upcase 
        until @computer_board.valid_coordinate?(user_input) && !@computer_board.cells[user_input].fired_upon?
        #   puts "You have already fired here.  Enter a new coordinate:"
        feedback_statement(user_input)
          user_input = gets.chomp.upcase
      end

        #this could be put into a helper method and then on line 82.5 we call it
      @computer_board.cells[user_input].fire_upon
        #puts @computer_board.render
        outcome = @computer_board.cells[user_input].render
        shot_message = case outcome
            when "M" then "was a miss."
            when "H" then "scored a hit!"
            when "X" then "sunk my battleship!"
            else "Oh no, something has gone wrong"
        end
      shot_art = case outcome
        when "M" then "                 
                                     |__
                                     |\/
                                     ---
                                     / | [
                              !      | |||
                            _/|     _/|-++'
                        +  +--|    |--|--|_ |-
                     { /|__|  |/\__|  |--- |||__/
                    +---------------___[}-_===_.'____                 

 __..._____--==/___]_|__|_____________________________[___\==--____,------' .7
|                                                                     BB-61/
 \_________________________________________________________________________|"
        when "H" then "                 
                                     |__
                                     |\/
                                     ---               _.__.  . .
                                     / | [          +8#8+..``
                              !      | |||     '.+#8##8#88#+-1`  '`   
                            _/|     _/|-++' +**#8###8#88###``
                        +  +--|    |--|-### |###88#=  ^""```
                     { /|__|  |/\__|  +8#8#++#8#/       
                    +--------------#+###+#_=#=_.'____                 
                                #\>##+./#++   |
 __..._____--==/___]_|__|_____#>-  @  -<#_______________[___\==--____,------' .7
|                               / | | \                                 BB-61/
 \_________________________________________________________________________|"
        when "X" then "                 
                                     |__
                                     |\/
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                     / | [            .                 .
           .         .         !      | |||         .
                 .          _/|     _/|-++'                   .
    .                   +  +--|    |--|--|_ |-              .
     .               { /|__|  |/\__|  |--- |||__/
        .           +---------------___[}-_===_.'____        .        
                               #\>##+./#++   |   #\>##+./#++ .
 __..._____->-  @  _<_|__|_____#>-  @  -<#_______#>-  @  -<#__\==--____,------' .7
|            / | | \            / | | \           / | | \              BB-61/
 \_________________________________________________________________________|"
        else ""

#       puts " \n Enter the coordinate for your shot: \n "
#           user_input = gets.chomp.upcase
#       until @computer_board.valid_coordinate?(user_input) && !@computer_board.cells[user_input].fired_upon?
#         #   puts "You have already fired here.  Enter a new coordinate:"
#         feedback_statement(user_input)
#           user_input = gets.chomp.upcase
#       end
#       #this could be put into a helper method and then on line 82.5 we call it
#           @computer_board.cells[user_input].fire_upon
#     #   puts @computer_board.render
#       outcome = @computer_board.cells[user_input].render
#       shot_message = case outcome
#       when "M" then "was a miss."
#       when "H" then "scored a hit!"
#       when "X" then "sunk my battleship!"
#       else "Oh no, something has gone wrong"

      end
      puts "#{shot_art} \n"
      puts "\n"
      puts "==========================Your shot on #{user_input} #{shot_message}========================== \n "
  end

  def feedback_statement(input)
    fired_upon_cells = @computer_board.cells.values.select {|cell| cell.fired_upon?}.map(&:coordinate)
    if fired_upon_cells.include?(input)
        puts "You have already fired here.  Enter a new coordinate:"
    elsif input.length < 2
        puts "This is invalid coordinate, please enter coordinate like B2"
    elsif input[0].to_i > 0
        puts "You must enter coordinate with letter first"
    else @computer_board.valid_coordinate?(input) && !@computer_board.cells[input].fired_upon?
        puts "This is invalid coordinate, please enter correct coordinate."
    end
  end

  def computer_turn_shot
          random_coords = @player_board.cells.keys.sample
      until @player_board.valid_coordinate?(random_coords) && !@player_board.cells[random_coords].fired_upon?
          random_coords = @player_board.cells.keys.sample
      end
          @player_board.cells[random_coords].fire_upon

    #   puts @player_board.render(true)

      computer_outcome = @player_board.cells[random_coords].render
      computer_shot_message = case computer_outcome
          when "M" then "was a miss."
          when "H" then "scored a hit!"
          when "X" then "sunk your battleship!"
          else "Oh no, something has gone wrong"
          end 
      shot_art = case computer_outcome
          when "M" then "                 
                                     |__
                                     |\/
                                     ---
                                     / | [
                              !      | |||
                            _/|     _/|-++'
                        +  +--|    |--|--|_ |-
                     { /|__|  |/\__|  |--- |||__/
                    +---------------___[}-_===_.'____                 

 __..._____--==/___]_|__|_____________________________[___\==--____,------' .7
|                                                                     BB-61/
 \_________________________________________________________________________|"
        when "H" then "                 
                                     |__
                                     |\/
                                     ---               _.__.  . .
                                     / | [          +8#8+..``
                              !      | |||     '.+#8##8#88#+-1`  '`   
                            _/|     _/|-++' +**#8###8#88###``
                        +  +--|    |--|-### |###88#=  ^""```
                     { /|__|  |/\__|  +8#8#++#8#/       
                    +--------------#+###+#_=#=_.'____                 
                                #\>##+./#++   |
 __..._____--==/___]_|__|_____#>-  @  -<#_______________[___\==--____,------' .7
|                               / | | \                                 BB-61/
 \_________________________________________________________________________|"
        when "X" then "                 
                                     |__
                                     |\/
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                     / | [            .                 .
           .         .         !      | |||         .
                 .          _/|     _/|-++'                   .
    .                   +  +--|    |--|--|_ |-              .
     .               { /|__|  |/\__|  |--- |||__/
        .           +---------------___[}-_===_.'____        .        
                               #\>##+./#++   |   #\>##+./#++ .
 __..._____->-  @  _<_|__|_____#>-  @  -<#_______#>-  @  -<#__\==--____,------' .7
|            / | | \            / | | \           / | | \              BB-61/
 \_________________________________________________________________________|"
        else ""
        end
        puts "#{shot_art} \n"
        puts "\n"
        puts "==========================My shot on #{random_coords} #{computer_shot_message}==========================\n "
    end

  def play_game
      until game_over?
          turn_start
          player_turn_shot
      break if player_won?
          computer_turn_shot
      end
      end_game
  end

  def game_over?
    player_won? || computer_won?
  end

  def player_won?
    [@computer_cruiser, @computer_submarine].all?(&:sunk?)
  end
   
  def computer_won?
    [@player_cruiser, @player_submarine].all?(&:sunk?)
  end

  def end_game
    if computer_won?
         puts "I Won! #{@player_name}, would you like to play again? (yes or no) \n "
    else
        puts "#{@player_name}, You Won! Would you like to play again? (yes or no) \n "
    end
    choice = gets.chomp.downcase
    case choice
    when "yes"
        run_game
    when "no"
        puts "Exciting game. Goodbye #{@player_name}"
        exit
    else
        puts "Invalid choice. Please enter 'yes' to play again or 'no' to quit."
        end_game
    end
 end
end                 
                     
       

   
                                
                    