require_relative 'board'
require_relative 'possible_moves'
require_relative 'player'

class Game
  def play
    print_introduction
  end

  private

  def print_introduction
    puts "\033[1m\e[31m-----------------------------------------------\e[0m\033[0m"
    puts "                  \033[1m\e[31mChess Game\e[0m\033[0m"
    puts "\033[1m\e[31m-----------------------------------------------\e[0m\033[0m"
  end
end