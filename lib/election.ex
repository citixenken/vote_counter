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
end
