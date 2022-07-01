defmodule WordleTest do
  use ExUnit.Case
  doctest Wordle

  describe "check_letter_in_word function" do
    test "returns uppercase when the letter is in the correct position" do
      word_of_the_day = String.split("water", "", trim: true)

      assert Wordle.check_letter_in_correct_position({"w", 0}, word_of_the_day) == "W"
      assert Wordle.check_letter_in_correct_position({"a", 1}, word_of_the_day) == "A"
      assert Wordle.check_letter_in_correct_position({"t", 2}, word_of_the_day) == "T"
      assert Wordle.check_letter_in_correct_position({"e", 3}, word_of_the_day) == "E"
      assert Wordle.check_letter_in_correct_position({"r", 4}, word_of_the_day) == "R"
    end

    test "returns lower when the letter is not in the correct position or letter not in word" do
      word_of_the_day = String.split("water", "", trim: true)

      assert Wordle.check_letter_in_correct_position({"w", 1}, word_of_the_day) == "w"
      assert Wordle.check_letter_in_correct_position({"a", 0}, word_of_the_day) == "a"
      assert Wordle.check_letter_in_correct_position({"t", 4}, word_of_the_day) == "t"
      assert Wordle.check_letter_in_correct_position({"s", 1}, word_of_the_day) == "s"
      assert Wordle.check_letter_in_correct_position({"z", 4}, word_of_the_day) == "z"
    end
  end

  describe "get_previous_portion_of_word function" do
    test "returns empty string when index is 0" do
      assert Wordle.get_previous_portion_of_word(0, ["t", "e", "s", "t", "s"]) == ""
    end

    test "returns the string up to the stated index" do
      assert Wordle.get_previous_portion_of_word(1, ["t", "e", "s", "t", "s"]) == "te"
      assert Wordle.get_previous_portion_of_word(2, ["t", "e", "s", "t", "s"]) == "tes"
      assert Wordle.get_previous_portion_of_word(3, ["t", "e", "s", "t", "s"]) == "test"
      assert Wordle.get_previous_portion_of_word(4, ["t", "e", "s", "t", "s"]) == "tests"
    end
  end

  describe "check_guess function" do
    test "returns [_ater] when guess is [water] and word is [alert] " do
      assert Wordle.check_guess(["w", "a", "t", "e", "r"], ["a", "l", "e", "r", "t"]) == [
               "_",
               "a",
               "t",
               "e",
               "r"
             ]
    end

    test "returns [WA_E_] when guess is [water] and word is [alert] " do
      assert Wordle.check_guess(["w", "a", "t", "e", "r"], ["w", "a", "v", "e", "d"]) == [
               "W",
               "A",
               "_",
               "E",
               "_"
             ]
    end
  end

  test "guess_with_correct_letters" do
    assert Wordle.determine_correct_letters_in_guess(["c", "l", "e", "a", "r"], [
             "a",
             "l",
             "e",
             "r",
             "t"
           ]) == [
             "c",
             "L",
             "E",
             "a",
             "r"
           ]

    assert Wordle.determine_correct_letters_in_guess(["b", "r", "o", "o", "m"], [
             "b",
             "l",
             "o",
             "o",
             "d"
           ]) == [
             "B",
             "r",
             "O",
             "O",
             "m"
           ]

    assert Wordle.determine_correct_letters_in_guess(["e", "v", "e", "r", "y"], [
             "j",
             "e",
             "l",
             "l",
             "y"
           ]) == [
             "e",
             "v",
             "e",
             "r",
             "Y"
           ]
  end
end

# Elixir questions for Chris

# Are module attributes the best way to handle global vars?
# How do I mock a module attribute in tests?
