defmodule Wordle do
  @moduledoc """
  based on the popular game Wordle: https://www.nytimes.com/games/wordle/index.html
  In this version the following indicates the letter guessed
  "_" indicates the letter is not in the word
  "p" indicates a p is in the word but not in the correct position
  "P" indicates a p is in the word and is in the correct position
  """
  def play(total_guesses, word_of_the_day) do
    # letters = "qwertyuiopasdfghjklzxcvbnm" |> String.split("", trim: true)
    # IO.inspect("Remaining letters: #{letters}")

    guess =
      IO.gets("What is your guess? (#{total_guesses + 1})\n")
      |> String.trim()
      |> String.split("", trim: true)

    total_guesses = total_guesses + 1
    guess = check_guess(guess, word_of_the_day)
    check_if_guess_correct(guess, total_guesses, word_of_the_day)
  end

  def check_guess(guess, word_of_the_day) do
    guess_with_correct_letters = determine_correct_letters_in_guess(guess, word_of_the_day)

    Enum.zip(guess_with_correct_letters, [0, 1, 2, 3, 4])
    |> Enum.map(&check_letter_in_word(&1, guess_with_correct_letters, word_of_the_day))
    |> IO.puts()
  end

  def determine_correct_letters_in_guess(guess, word_of_the_day) do
    Enum.zip(guess, [0, 1, 2, 3, 4])
    |> Enum.map(&check_letter_in_correct_position(&1, word_of_the_day))
  end

  def check_if_guess_correct(guess, total_guesses, word_of_the_day) do
    if String.downcase(Enum.join(guess)) == Enum.join(word_of_the_day) do
      IO.puts(
        "You won! The correct answer was #{word_of_the_day}. You got it in #{total_guesses} guesses"
      )
    else
      check_if_guesses_remain(total_guesses, word_of_the_day)
    end
  end

  def check_if_guesses_remain(total_guesses, _) when total_guesses == 6 do
    IO.puts("bad luck out of guesses")
  end

  def check_if_guesses_remain(total_guesses, word_of_the_day) do
    play(total_guesses, word_of_the_day)
  end

  def check_letter_in_correct_position({letter, index}, word_of_the_day) do
    corresponding_letter_of_index_to_check = Enum.at(word_of_the_day, index)

    if corresponding_letter_of_index_to_check == letter do
      String.upcase(letter)
    else
      String.downcase(letter)
    end
  end

  def get_previous_portion_of_word(0 = _index, _guess), do: ""

  def get_previous_portion_of_word(index, guess) do
    String.slice(Enum.join(guess), 0..index)
  end

  def check_letter_in_word({letter, index}, guess, word_of_the_day) do
    if letter == String.upcase(letter) do
      letter
    else
      if Enum.member?(word_of_the_day, letter) do
        occurences_of_letter_in_word = Enum.filter(word_of_the_day, fn x -> x == letter end)

        previous_portion_of_word = get_previous_portion_of_word(index, guess)

        letter_already_occured =
          previous_portion_of_word
          |> String.split("", trim: true)
          |> Enum.filter(&(&1 == letter))
          |> Kernel.length() >= 0

        letter_already_covered =
          letter_already_occured == Kernel.length(occurences_of_letter_in_word)

        all_occurences_are_already_correct =
          List.delete_at(guess, index)
          |> Enum.filter(&(letter == String.downcase(&1)))
          |> Enum.all?(&(String.upcase(&1) == &1))

        if letter_already_covered or
             (all_occurences_are_already_correct and
                Kernel.length(Enum.filter(guess, &(letter == String.downcase(&1)))) > 1) do
          "_"
        else
          letter
        end
      else
        "_"
      end
    end
  end
end
