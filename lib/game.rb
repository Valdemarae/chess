require_relative 'board'
require_relative 'possible_moves'
require_relative 'player'

class Game
  def play
    print_introduction
    create_players
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
end