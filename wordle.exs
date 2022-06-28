# based on the popular game Wordle: https://www.nytimes.com/games/wordle/index.html
#
defmodule Wordle do
  @word_of_the_day ["H", "E", "L", "L", "O"]

  def play(total_guesses) do
    guess =
      IO.gets("What is your guess?\n")
      |> String.trim()
      |> String.upcase()
      |> String.split("", trim: true)

    total_guesses = total_guesses + 1
    guess = check_guess(guess)
    check_if_guess_correct(guess, total_guesses)
  end

  def check_guess(guess) do
    a = Enum.zip(guess, [0, 1, 2, 3, 4])
    Enum.map(a, fn x -> check_letter_status(x) end) |> IO.inspect()
  end

  def check_if_guess_correct(guess, total_guesses) do
    if Enum.join(guess) == Enum.join(@word_of_the_day) do
      IO.inspect(
        "You won! The correcte answer was #{@word_of_the_day}. You got it in #{total_guesses} guesses"
      )
    else
      check_if_guesses_remain(total_guesses)
    end
  end

  def check_if_guesses_remain(total_guesses) when total_guesses == 6 do
    IO.inspect("bad luck out of guesses")
  end

  def check_if_guesses_remain(total_guesses) do
    play(total_guesses)
  end

  def check_letter_status({letter, index}) do
    if !Enum.member?(@word_of_the_day, letter) do
      "_"
    else
      check_letter_position(letter, index)
    end
  end

  def check_letter_position(letter, index) do
    corresponding_letter_of_index_to_check = Enum.at(@word_of_the_day, index)

    if corresponding_letter_of_index_to_check == letter do
      letter
    else
      String.downcase(letter)
    end
  end
end

Wordle.play(0)
