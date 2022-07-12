# based on the popular game Wordle: https://www.nytimes.com/games/wordle/index.html
# In this version the following indicates the letter guessed

defmodule Wordle do
  def play(total_guesses, word_of_the_day, remaining_letters) do
    guess = ask_user_for_guess()

    total_guesses = total_guesses + 1
    guess = check_guess(guess, word_of_the_day, total_guesses)
    check_if_guess_correct(guess, total_guesses, word_of_the_day, remaining_letters)
  end

  def ask_user_for_guess do
    IO.gets("")
    |> String.slice(0..4)
    |> String.trim()
    |> String.upcase()
    |> String.split("", trim: true)
    |> Enum.with_index(fn letter, index ->
      %{color: "grey", letter: letter, index: index}
    end)
  end

  def show_remaining_letters(used_letters) do
    all_letters = "qwertyuiopasdfghjklzxcvbnm" |> String.upcase() |> String.split("", trim: true)
    IO.puts("")

    Enum.filter(all_letters, fn el -> !Enum.member?(used_letters, el) end)
    |> Enum.each(fn letter -> IO.write("#{letter} ") end)

    IO.puts("")
    IO.puts("")

    used_letters
  end

  def check_guess(guess, word_of_the_day, total_guesses) do
    guess_with_correct_letters =
      Enum.map(guess, fn x -> check_letter_in_correct_position(x, word_of_the_day) end)

    guess_with_letters_in_word =
      Enum.map(guess_with_correct_letters, fn x ->
        check_letter_in_word(x, guess_with_correct_letters, word_of_the_day)
      end)

    print_guess(guess_with_letters_in_word, total_guesses)
    guess_with_letters_in_word
  end

  def print_guess(guess_with_letters_in_word, total_guesses) do
    IO.write("##{total_guesses} ")
    Enum.each(guess_with_letters_in_word, fn x -> write_with_color(x) end)
    IO.puts("")
  end

  def write_with_color(%{color: color, letter: letter}) when color == "green" do
    IO.write("#{letter |> Colors.green() |> Colors.bold()} ")
  end

  def write_with_color(%{color: color, letter: letter}) when color == "orange" do
    IO.write("#{letter |> Colors.magenta() |> Colors.bold()} ")
  end

  def write_with_color(%{letter: letter}) do
    IO.write("#{letter |> Colors.black() |> Colors.bold()} ")
  end

  def check_letter_in_correct_position(
        %{letter: letter, index: index},
        word_of_the_day
      ) do
    get_position_color(Enum.at(word_of_the_day, index) == letter, letter, index)
  end

  def get_position_color(letter_corresponds_to_index_letter, letter, index)
      when letter_corresponds_to_index_letter == true do
    %{color: "green", letter: letter, index: index}
  end

  def get_position_color(_, letter, index) do
    %{color: "grey", letter: letter, index: index}
  end

  def check_if_guess_correct(guess, total_guesses, word_of_the_day, remaining_letters) do
    if Enum.all?(guess, fn x -> x.color == "green" end) do
      IO.puts(
        "You won! The correct answer was #{word_of_the_day}. You got it in #{total_guesses} guesses"
      )
    else
      check_if_guesses_remain(total_guesses, word_of_the_day, guess, remaining_letters)
    end
  end

  def check_if_guesses_remain(total_guesses, word_of_the_day, _, _) when total_guesses == 6 do
    IO.puts("bad luck out of guesses, the word was #{word_of_the_day}")
  end

  def check_if_guesses_remain(total_guesses, word_of_the_day, guess, remaining_letters) do
    remaining_letters =
      Enum.map(guess, fn x -> x.letter end)
      |> Enum.concat(remaining_letters)
      |> show_remaining_letters()

    play(total_guesses, word_of_the_day, remaining_letters)
  end

  def get_previous_portion_of_word(index, _) when index == 0 do
    []
  end

  def get_previous_portion_of_word(index, guess) do
    Enum.filter(guess, fn x -> x.index < index end)
  end

  def check_letter_in_word(%{color: color, letter: letter, index: index}, _, _)
      when color == "green" do
    %{color: "green", letter: letter, index: index}
  end

  def check_letter_in_word(%{color: color, letter: letter, index: index}, guess, word_of_the_day) do
    if Enum.member?(word_of_the_day, letter) do
      letter_is_in_word(%{color: color, letter: letter, index: index}, guess, word_of_the_day)
    else
      %{color: "grey", letter: letter, index: index}
    end
  end

  def occurences_of_letter_in_word_of_the_day(letter, word_of_the_day) do
    length(Enum.filter(word_of_the_day, fn x -> x == letter end))
  end

  def letter_already_covered(index, guess, letter, word_of_the_day) do
    length(
      get_previous_portion_of_word(index, guess)
      |> Enum.filter(fn x -> x.color != "green" end)
      |> Enum.filter(fn x -> x.letter == letter end)
    ) >= occurences_of_letter_in_word_of_the_day(letter, word_of_the_day)
  end

  def all_occurences_of_letter_in_correct_position(letter, guess) do
    length(Enum.filter(guess, fn x -> x.letter == letter and x.color == "green" end))
  end

  def letter_occurences_all_correct_or_covered(index, guess, letter, word_of_the_day) do
    occurences_of_letter_in_word_of_the_day(letter, word_of_the_day) ==
      all_occurences_of_letter_in_correct_position(letter, guess) or
      letter_already_covered(index, guess, letter, word_of_the_day)
  end

  def letter_is_in_word(%{letter: letter, index: index}, guess, word_of_the_day) do
    if letter_occurences_all_correct_or_covered(index, guess, letter, word_of_the_day) do
      %{color: "grey", letter: letter, index: index}
    else
      %{color: "orange", letter: letter, index: index}
    end
  end
end

# Wordle.play(0, RandomWord.generate_random_word(), [])
