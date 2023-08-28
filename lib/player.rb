class Player
  attr_reader :name

  def initialize(player_number)
    @name = get_name(player_number)
  end

  private

  def get_name(player_number)
    if player_number == 1
      print 'White pieces player\'s name: '
    else
      print 'Black pieces player\'s name: '
    end
    if player_number == 0
      sleep 1
      puts 'Computer'
      sleep 1
      return 'Computer'
    else
      gets.chomp
    end
  end
end