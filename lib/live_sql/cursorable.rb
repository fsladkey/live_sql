module Cursorable

  def error
  end

  def quit
    system("clear")
    abort
  end

  def left
    @cursor_pos -= 1 unless @cursor_pos == 0
  end

  def right
    @cursor_pos += 1 unless @cursor_pos == @string.length - 1
  end

  def backspace
    if @string.length > 1
      @string.slice!(@cursor_pos - 1)
      @cursor_pos -= 1 unless @cursor_pos == 0
    end
    attempt_to_query_db
  end

  def delete
    if @string.length > 1
      @string.slice!(@cursor_pos)
    end
    attempt_to_query_db
  end

end
