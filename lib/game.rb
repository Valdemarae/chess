require_relative 'board'
require_relative 'possible_moves'
require_relative 'player'

class Game
  def play
    print_introduction
    create_players
    @board = Board.new
    @hash = @board.board_hash
    @moves = PossibleMoves.new
    @board.print_board
    loop do
      make_turn('white')
      break if game_over?()

      make_turn('black')
      break if game_over?()
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

  def create_players
    @first_player = Player.new(1)
    @second_player = Player.new(2)
    print_line
  end

  def make_choice_start(color)
    name = color == 'white' ? @first_player.name : @second_player.name
    puts "#{name}'s turn."
    start_position = nil
    loop do
      print "Choose #{color} piece you want to play with: "
      start_position = gets.chomp.downcase
      if start_position == 'help'
        print_instructions(color)
        next
      elsif valid_piece(start_position, color)
        if no_possible_moves?(start_position)
          puts "\e[31mChosen piece does not have possible moves. Try another one.\e[0m"
          next
        end
        break
      end
      puts "\e[31mWrong input! Type 'help' for instructions if you need them.\e[0m"
    end
    start_position
  end

  def make_choice_end(start_position)
    end_position = nil
    possible_moves = get_possible_moves_array(start_position)
    loop do
      print 'Choose position you want to go to: '
      end_position = gets.chomp.downcase
      if end_position == 'help'
        print_instructions
        next
      elsif possible_moves.include?(end_position)
        break
      end
      puts "\e[31mWrong input! Type 'help' for instructions if you need them.\e[0m"
    end
    end_position
  end

  def no_possible_moves?(position)
    array_of_moves = get_possible_moves_array(position)
    array_of_moves.empty?
  end

  def get_possible_moves_array(position)
    piece = @hash[position]
    if piece == '♙' || piece == '♟︎'
      return @moves.possible_for_pawn(position, @hash)
    elsif piece == '♘' || piece == '♞'
      return @moves.possible_for_knight(position, @hash)
    elsif piece == '♗' || piece == '♝'
      return @moves.possible_for_bishop(position, @hash)
    elsif piece == '♖' || piece == '♜'
      return @moves.possible_for_rook(position, @hash)
    elsif piece == '♕' || piece == '♛'
      return @moves.possible_for_queen(position, @hash)
    elsif piece == '♔' || piece == '♚'
      return @moves.possible_for_king(position, @hash)
    end
  end

  def print_instructions(color = nil)
    puts "\n1. Input must contain number of row and character of column."
    puts '2. Input length must be exactly 2.'
    puts "3. Chosen position must contain #{color} piece." if color
    puts '3. Chosen position must be empty or contain enemy piece.' unless color 
    puts "Position input examples: '5d', '1a', '8f'...\n\n"
  end

  def valid_piece(position, color)
    if color == 'white'
      @moves.there_is_white?(position, @hash)
    else
      @moves.there_is_black?(position, @hash)
    end
  end

  def make_turn(color)
    start_position = make_choice_start(color)
    end_position = make_choice_end(start_position)
    @board.update_board(start_position, end_position)
    @hash = @board.board_hash
    print_line
    @board.print_board
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
      return true if @hash[position] == '♔' || @hash[position] == '♚'
    end
  end

  def checkmate?(position)
    moves = get_all_pieces_possible_moves
    positions = get_possible_moves_array(position) + [position]
    positions.each do |position|
      return false unless moves.include? position
    end
    true
  end

  def get_all_pieces_possible_moves
    moves = []
    @hash.each do |key, value|
      next if value == ' '
      moves.concat get_possible_moves_array(key)
    end
    moves
  end
end