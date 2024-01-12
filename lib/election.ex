defmodule Election do
  defstruct(
    name: "Fellowship of the Ring Team Leader",
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

  def run(), do: %Election{} |> run()

  def run(:quit), do: :quit

  def run(election = %Election{}) do
    [IO.ANSI.clear(), IO.ANSI.cursor(0, 0), IO.ANSI.light_cyan()]
    |> IO.write()

    election
    |> view
    |> IO.write()

    command = IO.gets(">")

    election
    |> update(command)
    # maintain app state
    |> run()
  end

  def update(_election, ["q" <> _]) do
    :quit
  end

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))
  end

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    Map.put(election, :name, name)
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")
    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]

    # election
    # |> Map.put(:candidates, candidates)
    # |> Map.put(:next_id, election.next_id + 1)

    # OR

    %{election | candidates: candidates, next_id: election.next_id + 1}
  end

  def update(election, ["v" <> _, id]) do
    vote(election, Integer.parse(id))
  end

  defp vote(election, {id, _}) do
    candidates = Enum.map(election.candidates, &maybe_inc_vote(&1, id))
    Map.put(election, :candidates, candidates)
  end

  defp vote(election, _errors), do: election

  defp maybe_inc_vote(candidate, id) when is_integer(id) do
    maybe_inc_vote(candidate, candidate.id == id)
  end

  defp maybe_inc_vote(candidate, _inc_vote = false), do: candidate

  defp maybe_inc_vote(candidate, _inc_vote = true) do
    Map.update!(candidate, :votes, &(&1 + 1))
  end

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end
end
