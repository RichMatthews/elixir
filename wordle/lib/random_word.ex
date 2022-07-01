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
    Enum.random(@random_words) |> String.split("", trim: true)
  end
end
