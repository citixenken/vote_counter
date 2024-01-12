defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  setup do
    %{election: %Election{}}
  end

  test "updating election name from a command", ctx do
    command = "name Fellowship of the Ring Team Leader"
    election = Election.update(ctx.election, command)
    assert election == %Election{name: "Fellowship of the Ring Team Leader"}
  end

  test "adding a new candidate from a command", ctx do
    command = "a Gimli"
    election = Election.update(ctx.election, command)
    assert election == %Election{candidates: [Candidate.new(1, "Gimli")], next_id: 2}
  end

  test "voting for a candidate from a command" do
    command = "vote 1"
    election = %Election{candidates: [Candidate.new(1, "Aragorn")]} |> Election.update(command)

    assert election == %Election{candidates: [%Candidate{id: 1, name: "Aragorn", votes: 1}]}
  end

  test "invalid command" do
    command = "bdsdsb"
  end

  test "quitting the app", ctx do
    command = "quit"
    election = Election.update(ctx.election, command)
    assert election == :quit
  end
end
