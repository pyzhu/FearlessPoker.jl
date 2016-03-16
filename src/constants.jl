const RANKS = "A23456789TJQKA" # wrapped to create the straights
const SUITS = "cdhs"
const DECK = [string(f, s) for f in collect(RANKS[1:13]), s in split(SUITS, "")] |> vec |> sort
const STARTING_HANDS = collect(combinations(DECK, 2))