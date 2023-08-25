require_relative 'board'

class PossibleMoves
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

  end

  def possible_for_bishop(start_position, hash)

  end

  def possible_for_queen(start_position, hash)

  end

  def possible_for_king(start_position, hash)

  end

  private

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

  def there_is_black?(position, hash)
    hash[position] == '♚' || hash[position] == '♛' || hash[position] == '♜' || hash[position] == '♝' || hash[position] == '♞' || hash[position] == '♟︎'
  end

  def there_is_white?(position, hash)
    hash[position] == '♔' || hash[position] == '♕' || hash[position] == '♖' || hash[position] == '♗' || hash[position] == '♘' || hash[position] == '♙'
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
end

p PossibleMoves.new.possible_for_pawn('6d', Board.new.board_hash)
p PossibleMoves.new.possible_for_rook('5c', Board.new.board_hash)