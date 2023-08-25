class Player
  attr_reader :name

  def initialize(player_number)
    @name = get_name(player_number)
  end

  private

  def get_name(player_number)
    if player_number == 1
      print 'White pieces player name: '
    else
      print 'Black pieces player name: '
    end
    gets.chomp
  end
end