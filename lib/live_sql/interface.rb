require 'io/console'

class Interface
  attr_accessor :string

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  # oringal case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  
  def get_keyboard_input
    c = read_char

    case c
    when "\r"
      :error
    when "\e"
      :quit
    when "\e[C"
      "RIGHT ARROW"
      :right
    when "\e[D"
      "LEFT ARROW"
      :left
    when "\177"
      :backspace
    when "\004"
      :delete
     when "\e[3~"
       :delete
    when /^.$/
      c
    else
      :error
    end
  end

end
