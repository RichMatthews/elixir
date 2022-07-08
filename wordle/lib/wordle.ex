# based on the popular game Wordle: https://www.nytimes.com/games/wordle/index.html
# In this version the following indicates the letter guessed

defmodule RandomWord do
  @random_words [
    "notes",
    "ylems",
    "trued",
    "orpin",
    "ascot",
    "dryer",
    "goose",
    "trick",
    "nests",
    "matin",
    "iliad",
    "divot",
    "hosta",
    "emery",
    "limba",
    "sucks",
    "turks",
    "hints",
    "whist",
    "mimed",
    "cords",
    "glazy",
    "canny",
    "ducat",
    "amuse"
  ]

  def generate_random_word() do
    Enum.random(@random_words) |> String.upcase() |> String.split("", trim: true)
  end
end

defmodule Wordle do
  def play(total_guesses, word_of_the_day) do
    # letters = "qwertyuiopasdfghjklzxcvbnm" |> String.split("", trim: true)
    # IO.inspect("Remaining letters: #{letters}")

    guess =
      IO.gets("")
      |> String.slice(0..4)
      |> String.trim()
      |> String.upcase()
      |> String.split("", trim: true)
      |> Enum.with_index(fn letter, index ->
        %{color: "grey", letter: letter, index: index}
      end)

    total_guesses = total_guesses + 1
    guess = check_guess(guess, word_of_the_day)
    check_if_guess_correct(guess, total_guesses, word_of_the_day)
  end

  def check_guess(guess, word_of_the_day) do
    guess_with_correct_letters =
      Enum.map(guess, fn x -> check_letter_in_correct_position(x, word_of_the_day) end)

    guess_with_letters_in_word =
      Enum.map(guess_with_correct_letters, fn x ->
        check_letter_in_word(x, guess_with_correct_letters, word_of_the_day)
      end)

    Enum.each(guess_with_letters_in_word, fn x -> write_with_color(x) end)
    IO.puts("")
    guess_with_letters_in_word
  end

  def write_with_color(%{color: color, letter: letter}) do
    if color == "green" do
      IO.write("#{letter} " |> Colors.green() |> Colors.bold())
    else
      if color == "orange" do
        IO.write("#{letter} " |> Colors.magenta() |> Colors.bold())
      else
        IO.write("#{letter} " |> Colors.black() |> Colors.bold())
      end
    end
  end

  def check_letter_in_correct_position(
        %{letter: letter, index: index},
        word_of_the_day
      ) do
    corresponding_letter_of_index_to_check = Enum.at(word_of_the_day, index)

    if corresponding_letter_of_index_to_check == letter do
      %{color: "green", letter: letter, index: index}
    else
      %{color: "grey", letter: letter, index: index}
    end
  end

  def check_if_guess_correct(guess, total_guesses, word_of_the_day) do
    if Enum.all?(guess, fn x -> x.color == "green" end) do
      IO.puts(
        "You won! The correct answer was #{word_of_the_day}. You got it in #{total_guesses} guesses"
      )
    else
      check_if_guesses_remain(total_guesses, word_of_the_day)
    end
  end

  def check_if_guesses_remain(total_guesses, word_of_the_day) when total_guesses == 6 do
    IO.inspect("bad luck out of guesses, the word was #{word_of_the_day}")
  end

  def check_if_guesses_remain(total_guesses, word_of_the_day) do
    play(total_guesses, word_of_the_day)
  end

  def get_previous_portion_of_word(index, _) when index == 0 do
    []
  end

  def get_previous_portion_of_word(index, guess) do
    Enum.filter(guess, fn x -> x.index <= index end)
  end

  def check_letter_in_word(%{color: color, letter: letter, index: index}, guess, word_of_the_day) do
    if color == "green" do
      %{color: "green", letter: letter, index: index}
    else
      if Enum.member?(word_of_the_day, letter) do
        occurences_of_letter_in_word = Enum.filter(word_of_the_day, fn x -> x == letter end)

        previous_portion_of_word = get_previous_portion_of_word(index, guess)

        letter_already_occured =
          previous_portion_of_word
          |> Enum.filter(fn x -> x == letter end)
          |> length >= 0

        letter_already_covered = letter_already_occured == length(occurences_of_letter_in_word)

        all_occurences_are_already_correct =
          List.delete_at(guess, index)
          |> Enum.filter(fn x -> letter == x.letter end)
          |> Enum.all?(fn x -> x.color == "green" end)

        if letter_already_covered or
             (all_occurences_are_already_correct and
                Kernel.length(Enum.filter(guess, fn x -> letter == String.downcase(x.letter) end)) >
                  1) do
          %{color: "grey", letter: letter, index: index}
        else
        end

        %{color: "orange", letter: letter, index: index}
      else
        %{color: "grey", letter: letter, index: index}
      end
    end
  end
end

Wordle.play(0, RandomWord.generate_random_word())
