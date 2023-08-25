class Board
  def initialize
    @board_hash = create_board
  end

  def create_board
    add_pieces(create_empty_hash)
  end

  def create_empty_hash
    hash = {}
    for i in '1'..'8' do
      for j in 'a'..'h' do
        hash[i + j] = ' '
      end
    end
    hash
  end

  def add_pieces(hash)
    add_pawn(hash)
    add_rook(hash)
    add_knight(hash)
    add_bishop(hash)
    add_queen(hash)
    add_king(hash)
  end

  def add_pawn(hash)
    for i in 'a'..'h' do
      hash['2' + i] = '♙'
    end

    for i in 'a'..'h' do
      hash['7' + i] = '♟︎'
    end
  end

  def add_rook(hash)
    hash['1a'] = '♖'
    hash['1h'] = '♖'
    hash['8a'] = '♜'
    hash['8h'] = '♜'
  end

  def add_knight(hash)
    hash['1b'] = '♘'
    hash['1g'] = '♘'
    hash['8b'] = '♞'
    hash['8g'] = '♞'
  end

  def add_bishop(hash)
    hash['1c'] = '♗'
    hash['1f'] = '♗'
    hash['8c'] = '♝'
    hash['8f'] = '♝'
  end

  def add_queen(hash) 
    hash['1d'] = '♕'
    hash['8d'] = '♛'
  end

  def add_king(hash)
    hash['1e'] = '♔'
    hash['8e'] = '♚'
  end
end