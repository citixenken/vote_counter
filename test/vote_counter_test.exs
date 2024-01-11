defmodule VoteCounterTest do
  use ExUnit.Case
  doctest VoteCounter

  test "greets the world" do
    assert VoteCounter.hello() == :world
  end
end
