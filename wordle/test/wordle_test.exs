defmodule WordleTest do
  use ExUnit.Case
  doctest Wordle

  describe "check_letter_in_correct_position function" do
    test "returns color green when the letter is in the correct position, grey when it is not" do
      word_of_the_day = ["W", "A", "S", "T", "E"]

      assert Wordle.check_letter_in_correct_position(%{letter: "W", index: 0}, word_of_the_day) ==
               %{color: "green", letter: "W", index: 0}

      assert Wordle.check_letter_in_correct_position(%{letter: "A", index: 1}, word_of_the_day) ==
               %{color: "green", letter: "A", index: 1}

      assert Wordle.check_letter_in_correct_position(%{letter: "T", index: 2}, word_of_the_day) ==
               %{color: "grey", letter: "T", index: 2}

      assert Wordle.check_letter_in_correct_position(%{letter: "E", index: 3}, word_of_the_day) ==
               %{color: "grey", letter: "E", index: 3}

      assert Wordle.check_letter_in_correct_position(%{letter: "R", index: 4}, word_of_the_day) ==
               %{color: "grey", letter: "R", index: 4}
    end
  end

  describe "get_previous_portion_of_word function" do
    test "returns empty string when index is 0" do
      word_of_the_day = ["W", "A", "S", "T", "E"]

      assert Wordle.get_previous_portion_of_word(0, word_of_the_day) == []
    end

    test "returns the string up to the stated index" do
      guess = [
        %{color: "grey", letter: "W", index: 0},
        %{color: "grey", letter: "A", index: 1},
        %{color: "grey", letter: "T", index: 2},
        %{color: "grey", letter: "E", index: 3},
        %{color: "grey", letter: "R", index: 4}
      ]

      assert Wordle.get_previous_portion_of_word(1, guess) == [
               %{color: "grey", letter: "W", index: 0}
             ]

      assert Wordle.get_previous_portion_of_word(2, guess) == [
               %{color: "grey", letter: "W", index: 0},
               %{color: "grey", letter: "A", index: 1}
             ]

      assert Wordle.get_previous_portion_of_word(3, guess) == [
               %{color: "grey", letter: "W", index: 0},
               %{color: "grey", letter: "A", index: 1},
               %{color: "grey", letter: "T", index: 2}
             ]

      assert Wordle.get_previous_portion_of_word(4, guess) == [
               %{color: "grey", letter: "W", index: 0},
               %{color: "grey", letter: "A", index: 1},
               %{color: "grey", letter: "T", index: 2},
               %{color: "grey", letter: "E", index: 3}
             ]
    end
  end

  describe "write_with_color function" do
    test "returns green when color is green" do
      Wordle.write_with_color(%{color: "green", letter: "A"})
    end
  end

  describe "check_guess function" do
    test "returns the letters with the expected colors (1)" do
      guess = [
        %{color: "grey", letter: "W", index: 0},
        %{color: "grey", letter: "A", index: 1},
        %{color: "grey", letter: "T", index: 2},
        %{color: "grey", letter: "E", index: 3},
        %{color: "grey", letter: "R", index: 4}
      ]

      word_of_the_day = ["W", "A", "S", "T", "E"]

      result = [
        %{color: "green", letter: "W", index: 0},
        %{color: "green", letter: "A", index: 1},
        %{color: "orange", letter: "T", index: 2},
        %{color: "orange", letter: "E", index: 3},
        %{color: "grey", letter: "R", index: 4}
      ]

      assert Wordle.check_guess(guess, word_of_the_day, 1) == result
    end

    test "returns the letters with the expected colors (2)" do
      guess = [
        %{color: "grey", letter: "A", index: 0},
        %{color: "grey", letter: "L", index: 1},
        %{color: "grey", letter: "L", index: 2},
        %{color: "grey", letter: "O", index: 3},
        %{color: "grey", letter: "T", index: 4}
      ]

      word_of_the_day = ["L", "O", "L", "L", "Y"]

      result = [
        %{color: "grey", letter: "A", index: 0},
        %{color: "orange", letter: "L", index: 1},
        %{color: "green", letter: "L", index: 2},
        %{color: "orange", letter: "O", index: 3},
        %{color: "grey", letter: "T", index: 4}
      ]

      assert Wordle.check_guess(guess, word_of_the_day, 1) == result
    end

    test "returns the letters with the expected colors (3)" do
      guess = [
        %{color: "grey", letter: "A", index: 0},
        %{color: "grey", letter: "S", index: 1},
        %{color: "grey", letter: "S", index: 2},
        %{color: "grey", letter: "E", index: 3},
        %{color: "grey", letter: "T", index: 4}
      ]

      word_of_the_day = ["S", "A", "I", "N", "T"]

      result = [
        %{color: "orange", letter: "A", index: 0},
        %{color: "orange", letter: "S", index: 1},
        %{color: "grey", letter: "S", index: 2},
        %{color: "grey", letter: "E", index: 3},
        %{color: "green", letter: "T", index: 4}
      ]

      assert Wordle.check_guess(guess, word_of_the_day, 1) == result
    end

    test "returns the letters with the expected colors (4)" do
      guess = [
        %{color: "grey", letter: "G", index: 0},
        %{color: "grey", letter: "A", index: 1},
        %{color: "grey", letter: "S", index: 2},
        %{color: "grey", letter: "S", index: 3},
        %{color: "grey", letter: "Y", index: 4}
      ]

      word_of_the_day = ["S", "T", "A", "S", "H"]

      result = [
        %{color: "grey", letter: "G", index: 0},
        %{color: "orange", letter: "A", index: 1},
        %{color: "orange", letter: "S", index: 2},
        %{color: "green", letter: "S", index: 3},
        %{color: "grey", letter: "Y", index: 4}
      ]

      assert Wordle.check_guess(guess, word_of_the_day, 1) == result
    end

    test "returns the letters with the expected colors (5)" do
      guess = [
        %{color: "grey", letter: "D", index: 0},
        %{color: "grey", letter: "A", index: 1},
        %{color: "grey", letter: "D", index: 2},
        %{color: "grey", letter: "D", index: 3},
        %{color: "grey", letter: "Y", index: 4}
      ]

      word_of_the_day = ["A", "D", "I", "E", "U"]

      result = [
        %{color: "orange", letter: "D", index: 0},
        %{color: "orange", letter: "A", index: 1},
        %{color: "grey", letter: "D", index: 2},
        %{color: "grey", letter: "D", index: 3},
        %{color: "grey", letter: "Y", index: 4}
      ]

      assert Wordle.check_guess(guess, word_of_the_day, 1) == result
    end
  end
end
