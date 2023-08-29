require 'yaml'
require_relative 'board'
require_relative 'possible_moves'
require_relative 'player'
require_relative 'save_load'
require_relative 'computer'
require_relative 'make_choice'

class Game
  include SaveLoad
  include Computer
  include MakeChoice
  include PossibleMoves

  def play
    print_introduction
    if new_or_existing_game == 'existing'
      load_game
    else
      enemy = choose_enemy
      if enemy == 'Computer'
        create_players(0)
      else
        create_players
      end
      @board = Board.new
    end
    @hash = @board.board_hash
    @board.print_board
    loop do
      result = make_turn('white')
      break if result == 'exit'
      if game_over?()
        print_winner(@first_player.name)
        break 
      end

      result = make_turn('black')
      break if result == 'exit'
      if game_over?()
        print_winner(@second_player.name)
        break
      end
    end
  end

  private

  def print_introduction
    print_line
    puts "                  \033[1m\e[31mChess Game\e[0m\033[0m"
    print_line
  end

  def print_line
    puts "\033[1m\e[31m-----------------------------------------------\e[0m\033[0m"
  end

  def create_players(number = nil)
    @first_player = Player.new(1)
    unless number
      @second_player = Player.new(2)
    else
      @second_player = Player.new(number)
    end
    print_line
  end

  def print_instructions(color = nil)
    puts "\n1. Input must contain number of row and character of column."
    puts '2. Input length must be exactly 2.'
    if color
      puts "3. Chosen position must contain #{color} piece." 
      puts '4. Type \'save\' to save the game.'
      puts "5. Type 'exit' to end the game. Be sure to save it to be able to continue playing next time."
    else
      puts '3. Chosen position must be empty or contain enemy piece.'
    end
    puts "Position input examples: '5d', '1a', '8f'...\n\n"
  end

  def make_turn(color)
    unless color == 'black' && @second_player.name == 'Computer'
      start_position = make_choice_start(color)
      return 'exit' if start_position == 'exit'
      end_position = make_choice_end(start_position)
    else
      start_position = computer_makes_start_choice
      end_position = computer_makes_end_choice(start_position)
    end
    @board.update_board(start_position, end_position)
    @hash = @board.board_hash
    pawn_promotion(color) if pawn_reached_top?()
    print_line
    @board.print_board
    puts "\e[31mCheck!\e[0m" if check?()
  end

  def game_over?
    king_positions = []
    @hash.each do |key, value|
      if value == '♔' || value == '♚'
        king_positions.push key
      end
    end
    no_king_left?() || (checkmate?(king_positions[0]) || checkmate?(king_positions[1]))
  end

  def no_king_left?
    !(@hash.has_value?('♔') && @hash.has_value?('♚'))
  end

  def check?
    moves = get_all_pieces_possible_moves
    moves.each do |position|
      if @hash[position] == '♔' || @hash[position] == '♚'
        return true 
      end
    end
    false
  end

  def checkmate?(position)
    moves = get_all_pieces_possible_moves(position)
    positions = get_possible_moves_array(position) + [position]
    positions.each do |key|
      return false unless moves.include? key
    end
    puts "\e[31mCheckmate!\e[0m"
    true
  end

  def print_winner(name)
    puts "\e[31mGame over! #{name} won!\e[0m"
  end

  def pawn_promotion(color)
    new_piece = nil
    if color == 'black' && @second_player.name == 'Computer'
      new_piece = 'queen'
    else
      get_pawn_promotion_piece
    end
    for i in 'a'..'h' do
      if @hash['1' + i] == '♟'
        position = '1' + i
        break
      elsif @hash['8' + i] == '♙'
        position = '8' + i
        break
      end
    end
    @board.pawn_promotion(position, new_piece, color)
    @hash = @board.board_hash
  end

  def pawn_reached_top?
    for i in 'a'..'h' do
      return true if @hash['1' + i] == '♟' || @hash['8' + i] == '♙'
    end
    false
  end 
end