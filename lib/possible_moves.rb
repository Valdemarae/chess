require_relative 'board'

class PossibleMoves
  def possible_for_pawn(start_position, hash)
    positions_array = []
    if pawn_color_white?(start_position, hash)
      one_up = (start_position[0].to_i + 1).to_s + start_position[1]
      positions_array << one_up if position_empty?(one_up, hash)

      two_up = (start_position[0].to_i + 2).to_s + start_position[1]
      positions_array << two_up if position_empty?(one_up, hash) && position_empty?(two_up, hash) && first_move?(start_position)

      diagonal_up_left = (start_position[0].to_i + 1).to_s + (start_position[1].ord - 1).chr
      positions_array << diagonal_up_left if there_is_black?(diagonal_up_left, hash)

      diagonal_up_right = (start_position[0].to_i + 1).to_s + (start_position[1].ord + 1).chr
      positions_array << diagonal_up_right if there_is_black?(diagonal_up_right, hash)
    else
      one_down = (start_position[0].to_i - 1).to_s + start_position[1]
      positions_array << one_down if position_empty?(one_down, hash)

      two_down = (start_position[0].to_i - 2).to_s + start_position[1]
      positions_array << two_down if position_empty?(one_down, hash) && position_empty?(two_down, hash) && first_move?(start_position)

      diagonal_down_left = (start_position[0].to_i - 1).to_s + (start_position[1].ord - 1).chr
      positions_array << diagonal_down_left if there_is_white?(diagonal_down_left, hash)

      diagonal_down_right = (start_position[0].to_i - 1).to_s + (start_position[1].ord + 1).chr
      positions_array << diagonal_down_right if there_is_white?(diagonal_down_right, hash)
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

  def first_move?(position)
    if pawn_color_white?(position)
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