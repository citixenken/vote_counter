defmodule Election do
  defstruct(
    name: "Governor",
    candidates: [
      Candidate.new(1, "Gandalf"),
      Candidate.new(2, "Aragorn"),
      Candidate.new(3, "Frodo"),
      Candidate.new(4, "Sam"),
      Candidate.new(5, "Pippin"),
      Candidate.new(6, "Merry"),
      Candidate.new(7, "Legolas"),
      Candidate.new(8, "Gimli"),
      Candidate.new(9, "Boromir")
    ],
    next_id: 10
  )

  def view_header(election) do
    "Election for: #{election.name}\n"
  end

  def view_body(election) do
    election.candidates
    |> sort_candidates_by_votes_desc()
    |> candidates_to_strings()
    |> prepend_candidates_header()
  end

  defp sort_candidates_by_votes_desc(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end

  defp candidates_to_strings(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  defp prepend_candidates_header(candidates) do
    [
      "ID\tVotes\tName\n",
      "-------------------------\n"
      | candidates
    ]
  end

  def view_footer() do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd <candidate>, (v)ote <id>, (q)uit\n"
    ]
  end

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    Map.put(election, :name, name)
  end

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end
end
