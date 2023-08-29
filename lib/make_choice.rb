module MakeChoice
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

  def get_pawn_promotion_piece
    loop do
      print "Pawn promotion! Choose what you would like it to be. Type 'queen', 'rook', 'bishop' or 'knight': "
      new_piece = gets.chomp.downcase
      break if new_piece == 'queen' || new_piece == 'rook' || new_piece == 'bishop' || new_piece == 'knight'
      puts 'Wrong input! Try again!'
    end
  end
end