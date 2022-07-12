defmodule RandomWord do
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "some url")
  plug(Tesla.Middleware.JSON)

  def generate_random_word() do
    {:ok, json} = get("https://random-word-api.herokuapp.com/word?length=5")

    [h | _] = json.body
    h |> String.upcase() |> String.split("", trim: true)
  end
end
