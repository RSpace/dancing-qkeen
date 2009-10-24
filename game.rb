#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'chingu'
include Gosu
include Chingu

#
# We use Chingu::Window instead of Gosu::Window
#
class Game < Chingu::Window
  def initialize
    super(640, 480)       # This is always needed if you want to take advantage of what chingu offers
    self.caption = 'Dancing QKeen' # Window title
    
    push_game_state(Play) # Start game directly in play state
  end
end

class Play < Chingu::GameState
  def initialize
    super
    
    self.input = { :escape => :close }

    @keen = Keen.create
    @keen.input = {
      :holding_left => :move_left,
      :holding_right => :move_right,
      :released_left => :stand_left,
      :released_right => :stand_right,
      :holding_up => :look_up,
      :holding_down => :look_down,
      :released_up => :stand,
      :released_down => :stand
    }    
  end
  
  def close
    exit
  end
end


#
# If we create classes from Chingu::GameObject we get stuff for free.
# The accessors image,x,y,zorder,angle,factor_x,factor_y,center_x,center_y,mode,alpha.
# We also get a default #draw which draws the image to screen with the parameters listed above.
# You might recognize those from #draw_rot - http://www.libgosu.org/rdoc/classes/Gosu/Image.html#M000023
# And in it's core, that's what Chingu::GameObject is, an encapsulation of draw_rot with some extra cheese.
# For example, we get automatic calls to draw/update with Chingu::GameObject, which usually is what you want.
# You could stop this by doing: @keen = Keen.new(:draw => false, :update => false)
#
class Keen < Chingu::GameObject
  attr_accessor :direction
  
  def initialize

    # Load graphics
    @standing_left  = Image['keen_standing_left.png']
    @standing_right = Image['keen_standing_right.png']
    @running_left   = Chingu::Animation.new(:file => 'keen_running_left.png', :size => [20,32])
    @running_right  = Chingu::Animation.new(:file => 'keen_running_right.png', :size => [20,32])
    @looking_up     = Image['keen_looking_up.png']
    @looking_down    = Chingu::Animation.new(:file => 'keen_looking_down.png', :size => [24,32], :loop => false)

    # Initialize in window
    super(:x => $window.width/2, :y => $window.height/2)
    stand_left
  end
  
  def stand_left
    self.image = @standing_left
    self.direction = :left
  end

  def stand_right
    self.image = @standing_right
    self.direction = :right
  end
  
  def stand
    self.direction == :right ? stand_right : stand_left
    @looking_down.reset!
  end

  def move_left
    self.image = @running_left.next
    self.direction = :left
  end

  def move_right
    self.image = @running_right.next
    self.direction = :right
  end
  
  def look_up
    self.image = @looking_up
  end

  def look_down
    self.image = @looking_down.next
  end
  
end

Game.new.show   # Start the Game update/draw loop!