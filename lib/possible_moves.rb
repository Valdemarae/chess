module PossibleMoves
  def possible_for_pawn(start_position, hash)
    positions_array = []
    color = 'white' if there_is_white?(start_position, hash)
    if color == 'white'
      adjusted_height_by_one = (start_position[0].to_i + 1).to_s
      adjusted_height_by_two = (start_position[0].to_i + 2).to_s
    else
      adjusted_height_by_one = (start_position[0].to_i - 1).to_s
      adjusted_height_by_two = (start_position[0].to_i - 2).to_s 
    end
    changed_height_by_one = adjusted_height_by_one + start_position[1]
    changed_height_by_two = adjusted_height_by_two + start_position[1]
    diagonal_left = adjusted_height_by_one + (start_position[1].ord - 1).chr
    diagonal_right = adjusted_height_by_one + (start_position[1].ord + 1).chr

    positions_array << changed_height_by_one if position_empty?(changed_height_by_one, hash)
    if possible_double_for_pawn(start_position, changed_height_by_one, changed_height_by_two, hash)
      positions_array << changed_height_by_two 
    end
    positions_array << diagonal_left if there_is_enemy?(diagonal_left, hash, color)
    positions_array << diagonal_right if there_is_enemy?(diagonal_right, hash, color)

    positions_array
  end

  def possible_for_rook(start_position, hash)
    positions_array = []
    color = 'white' if there_is_white?(start_position, hash)
    position_up = (start_position[0].to_i + 1).to_s + start_position[1]
    loop do
      positions_array << position_up if empty_or_enemy_there?(position_up, hash, color)
      break if enemy_or_not_empty_there?(position_up, hash, color)
      position_up = (position_up[0].to_i + 1).to_s + start_position[1]
    end
    position_down = (start_position[0].to_i - 1).to_s + start_position[1]
    loop do
      positions_array << position_down if empty_or_enemy_there?(position_down, hash, color)
      break if enemy_or_not_empty_there?(position_down, hash, color)
      position_down = (position_down[0].to_i - 1).to_s + start_position[1]
    end
    position_right = start_position[0] + (start_position[1].ord + 1).chr
    loop do
      positions_array << position_right if empty_or_enemy_there?(position_right, hash, color)
      break if enemy_or_not_empty_there?(position_right, hash, color)
      position_right = start_position[0] + (position_right[1].ord + 1).chr
    end
    position_left = start_position[0] + (start_position[1].ord - 1).chr
    loop do
      positions_array << position_left if empty_or_enemy_there?(position_left, hash, color)
      break if enemy_or_not_empty_there?(position_left, hash, color)
      position_left = start_position[0] + (position_left[1].ord - 1).chr
    end
    positions_array
  end

  def possible_for_knight(start_position, hash)
    color = 'white' if there_is_white?(start_position, hash)
    position_number = start_position[0].to_i
    position_char_order = start_position[1].ord
    a = (position_number + 2).to_s + (position_char_order - 1).chr
    b = (position_number + 2).to_s + (position_char_order + 1).chr
    c = (position_number - 2).to_s + (position_char_order - 1).chr
    d = (position_number - 2).to_s + (position_char_order + 1).chr
    e = (position_number + 1).to_s + (position_char_order - 2).chr
    f = (position_number - 1).to_s + (position_char_order - 2).chr
    g = (position_number + 1).to_s + (position_char_order + 2).chr
    h = (position_number - 1).to_s + (position_char_order + 2).chr
    [a,b,c,d,e,f,g,h].filter {|i| empty_or_enemy_there?(i, hash, color)}
  end

  def possible_for_bishop(start_position, hash)
    positions_array = []
    color = 'white' if there_is_white?(start_position, hash)
    up_left = (start_position[0].to_i + 1).to_s + (start_position[1].ord - 1).chr
    loop do
      positions_array << up_left if empty_or_enemy_there?(up_left, hash, color)
      break if enemy_or_not_empty_there?(up_left, hash, color)
      up_left = (up_left[0].to_i + 1).to_s + (up_left[1].ord - 1).chr
    end
    up_right = (start_position[0].to_i + 1).to_s + (start_position[1].ord + 1).chr
    loop do
      positions_array << up_right if empty_or_enemy_there?(up_right, hash, color)
      break if enemy_or_not_empty_there?(up_right, hash, color)
      up_right = (up_right[0].to_i + 1).to_s + (up_right[1].ord + 1).chr
    end
    down_left = (start_position[0].to_i - 1).to_s + (start_position[1].ord - 1).chr
    loop do
      positions_array << down_left if empty_or_enemy_there?(down_left, hash, color)
      break if enemy_or_not_empty_there?(down_left, hash, color)
      down_left = (down_left[0].to_i - 1).to_s + (down_left[1].ord - 1).chr
    end
    down_right = (start_position[0].to_i - 1).to_s + (start_position[1].ord + 1).chr
    loop do
      positions_array << down_right if empty_or_enemy_there?(down_right, hash, color)
      break if enemy_or_not_empty_there?(down_right, hash, color)
      down_right = (down_right[0].to_i - 1).to_s + (down_right[1].ord + 1).chr
    end
    positions_array
  end

  def possible_for_queen(start_position, hash)
    possible_for_bishop(start_position, hash) + possible_for_rook(start_position, hash)
  end

  def possible_for_king(start_position, hash)
    color = 'white' if there_is_white?(start_position, hash)
    position_number = start_position[0].to_i
    position_char_order = start_position[1].ord
    a = (position_number + 1).to_s + (position_char_order - 1).chr
    b = (position_number + 1).to_s + start_position[1]
    c = (position_number + 1).to_s + (position_char_order + 1).chr
    d = start_position[0] + (position_char_order - 1).chr
    e = start_position[0] + (position_char_order + 1).chr
    f = (position_number - 1).to_s + (position_char_order - 1).chr
    g = (position_number - 1).to_s + start_position[1]
    h = (position_number - 1).to_s + (position_char_order + 1).chr
    [a,b,c,d,e,f,g,h].filter {|i| empty_or_enemy_there?(i, hash, color)}
  end

  def there_is_black?(position, hash)
    hash[position] == '♚' || hash[position] == '♛' || hash[position] == '♜' || hash[position] == '♝' || hash[position] == '♞' || hash[position] == '♟︎'
  end

  def there_is_white?(position, hash)
    hash[position] == '♔' || hash[position] == '♕' || hash[position] == '♖' || hash[position] == '♗' || hash[position] == '♘' || hash[position] == '♙'
  end

  def position_empty?(position, hash)
    return true if hash[position] == ' '
    false
  end

  def first_move?(position, hash)
    if there_is_white?(position, hash)
      return true if position[0] == '2'
    else
      return true if position[0] == '7'
    end
    false
  end
  
  def there_is_enemy?(position, hash, color)
    if color == 'white'
      return there_is_black?(position, hash)
    else
      return there_is_white?(position, hash)
    end
  end

  def possible_double_for_pawn(start_position, changed_height_by_one, changed_height_by_two, hash)
    position_empty?(changed_height_by_one, hash) && position_empty?(changed_height_by_two, hash) && first_move?(start_position, hash)
  end

  def empty_or_enemy_there?(position, hash, color)
    position_empty?(position, hash) || there_is_enemy?(position, hash, color)
  end

  def enemy_or_not_empty_there?(position, hash, color)
    there_is_enemy?(position, hash, color) || !position_empty?(position, hash)
  end

  def no_possible_moves?(position)
    array_of_moves = get_possible_moves_array(position)
    array_of_moves.empty?
  end

  def get_possible_moves_array(position)
    piece = @hash[position]
    if piece == '♙' || piece == '♟︎'
      return possible_for_pawn(position, @hash)
    elsif piece == '♘' || piece == '♞'
      return possible_for_knight(position, @hash)
    elsif piece == '♗' || piece == '♝'
      return possible_for_bishop(position, @hash)
    elsif piece == '♖' || piece == '♜'
      return possible_for_rook(position, @hash)
    elsif piece == '♕' || piece == '♛'
      return possible_for_queen(position, @hash)
    elsif piece == '♔' || piece == '♚'
      return possible_for_king(position, @hash)
    end
  end

  def valid_piece(position, color)
    if color == 'white'
      there_is_white?(position, @hash)
    else
      there_is_black?(position, @hash)
    end
  end

  def get_all_pieces_possible_moves(position = nil)
    moves = []
    if position
      color = 'white' if there_is_white?(position, @hash)
    end
    @hash.each do |key, value|
      next if value == ' '
      if position
        if color == 'white'
          next if there_is_white?(key, @hash)
        else
          next if there_is_black?(key, @hash)
        end
      end
      moves.concat get_possible_moves_array(key)
    end
    moves
  end
end