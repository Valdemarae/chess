require_relative 'board'

class PossibleMoves
  def possible_for_pawn(start_position, hash)
    positions_array = []
    if pawn_color_white?(start_position, hash)
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
    if position_empty?(changed_height_by_one, hash) && position_empty?(changed_height_by_two, hash) && first_move?(start_position, hash)
      positions_array << changed_height_by_two 
    end
    if pawn_color_white?(start_position, hash)
      positions_array << diagonal_left if there_is_black?(diagonal_left, hash)
      positions_array << diagonal_right if there_is_black?(diagonal_right, hash)
    else
      positions_array << diagonal_left if there_is_white?(diagonal_left, hash)
      positions_array << diagonal_right if there_is_white?(diagonal_right, hash)
    end
    positions_array
  end

  def possible_for_rook(start_position, hash)

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

  def pawn_color_white?(position, hash)
    return true if hash[position] == '♙'
    false
  end

  def not_beyond_board?(position, hash)
    hash.has_key?(position)
  end

  def position_empty?(position, hash)
    return true if hash[position] == ' '
    false
  end

  def first_move?(position, hash)
    if pawn_color_white?(position, hash)
      return true if position[0] == '2'
    else
      return true if position[0] == '7'
    end
    false
  end

  def there_is_black?(position, hash)
    hash[position] == '♚' || hash[position] == '♛' || hash[position] == '♜' || hash[position] == '♝' || hash[position] == '♞' || hash[position] == '♟︎'
  end

  def there_is_white?(position, hash)
    hash[position] == '♔' || hash[position] == '♕' || hash[position] == '♖' || hash[position] == '♗' || hash[position] == '♘' || hash[position] == '♙'
  end
end
