require 'yaml'
require_relative 'board'
require_relative 'possible_moves'
require_relative 'player'

class Game
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
    @moves = PossibleMoves.new
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
      elsif start_position == 'save'
        save_game
        next
      elsif start_position == 'exit'
        break
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
    if color
      puts "3. Chosen position must contain #{color} piece." 
      puts '4. Type \'save\' to save the game.'
      puts "5. Type 'exit' to end the game. Be sure to save it to be able to continue playing next time."
    else
      puts '3. Chosen position must be empty or contain enemy piece.'
    end
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

  def get_all_pieces_possible_moves(position = nil)
    moves = []
    @hash.each do |key, value|
      next if value == ' ' || key == position
      moves.concat get_possible_moves_array(key)
    end
    moves
  end

  def print_winner(name)
    puts "\e[31mGame over! #{name} won!\e[0m"
  end

  def pawn_promotion(color)
    new_piece = nil
    if color == 'black' && @second_player.name == 'Computer'
      new_piece = 'queen'
    else
      loop do
        print "Pawn promotion! Choose what you would like it to be. Type 'queen', 'rook', 'bishop' or 'knight': "
        new_piece = gets.chomp.downcase
        break if new_piece == 'queen' || new_piece == 'rook' || new_piece == 'bishop' || new_piece == 'knight'
        puts 'Wrong input! Try again!'
      end
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

  def save_game
    name = "#{@first_player.name} vs #{@second_player.name}"
    data_array = YAML.load_stream(File.read('saved_games/saved_data.yml'))
    changed = false
    data_array.each_with_index do |saved_data, index|
      if saved_data[:name] == name
        data_array[index][:board] = @board
        data = YAML.dump(data_array[0])
        File.open('saved_games/saved_data.yml', 'w') {|f| f.write data}
        changed = true
      end
    end
    if changed
      for i in 1...data_array.length do
        data = YAML.dump(data_array[i])
        File.open('saved_games/saved_data.yml', 'a') {|f| f.write data}
      end
    else
      data = YAML.dump({name: name, board: @board, player1: @first_player, player2: @second_player})
      File.open('saved_games/saved_data.yml', 'a') {|f| f.write data}
    end
    puts "\e[32mThe game has been saved and named as '#{name}'.\e[0m"
    puts "\e[32mNow you can type 'exit' and continue the game next time.\e[0m"
  end

  def load_game
    data_array = YAML.load_stream(File.read('saved_games/saved_data.yml'))
    data = get_game_data(data_array)
    @board = data[:board]
    @first_player = data[:player1]
    @second_player = data[:player2]
  end

  def get_game_data(data_array)
    data_array.each_with_index do |data, index|
      puts "[#{index + 1}] #{data[:name]}"
    end
    index = nil
    loop do
      print 'Choose your saved game number: '
      index = gets.chomp.to_i - 1
      break if index.between?(0, data_array.length - 1)
    end
    print_line
    data_array[index]
  end

  def new_or_existing_game
    puts '[1] New game'
    puts '[2] Load saved game'
    result = nil
    loop do
      print 'Choose number: '
      result = gets.chomp.to_i
      break if result.between?(1,2)
    end
    print_line
    'existing' if result == 2
  end

  def choose_enemy
    puts '[1] Play against a friend'
    puts '[2] Play against computer'
    answer = nil
    loop do
      print 'Choose number: '
      answer = gets.chomp.to_i
      break if answer.between?(1,2)
    end
    answer == 1 ? 'Friend' : 'Computer'
  end

  def computer_makes_start_choice
    puts 'Computer\'s turn.'
    unless check?()
      pieces = []
      @hash.each_key do |key|
        pieces.push key if valid_piece(key, 'black')
      end
      pieces_that_can_beat_enemy = []
      pieces.each do |piece|
        moves = get_possible_moves_array(piece)
        moves.each do |move|
          if @moves.there_is_white?(move, @hash)
            pieces_that_can_beat_enemy.push piece
            break
          end
        end
      end
      unless pieces_that_can_beat_enemy.empty?
        start_position = pieces_that_can_beat_enemy.sample
      else
        loop do
          start_position = pieces.sample
          break unless no_possible_moves?(start_position)
        end
      end
    else
      start_position = @hash.key('♚')
    end
    print "It chooses piece: "
    sleep 1
    puts start_position
    start_position
  end

  def computer_makes_end_choice(start_position)
    moves = get_possible_moves_array(start_position)
    if check?()
      all_pieces_moves = get_all_pieces_possible_moves(start_position)
      moves.filter! {|move| !all_pieces_moves.include?(move)}
    end
    moves_to_enemy_position = []
    moves.each do |move|
      moves_to_enemy_position.push move if @moves.there_is_white?(move, @hash)
    end
    end_position = moves_to_enemy_position.empty? ? moves.sample : moves_to_enemy_position.sample
    print "It goes to: "
    sleep 1
    puts end_position
    sleep 1
    end_position
  end
end