module Computer
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
          if there_is_white?(move, @hash)
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
      moves_to_enemy_position.push move if there_is_white?(move, @hash)
    end
    end_position = moves_to_enemy_position.empty? ? moves.sample : moves_to_enemy_position.sample
    print "It goes to: "
    sleep 1
    puts end_position
    sleep 1
    end_position
  end
end