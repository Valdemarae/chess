class Board
  attr_reader :board_hash

  def initialize
    @board_hash = create_board
  end

  def print_board
    puts '           a  b  c  d  e  f  g  h'
    8.downto(1) do |i|
      print '         ' + i.to_s
      for j in 'a'..'h' do
        print "[#{@board_hash[i.to_s + j]}]"
      end
      puts i
    end
    puts '           a  b  c  d  e  f  g  h'
  end

  def update_board(start_position, end_position)
    piece = @board_hash[start_position]
    @board_hash[start_position] = ' '
    @board_hash[end_position] = piece
  end

  private

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
    hash
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