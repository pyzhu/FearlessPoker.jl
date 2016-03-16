function evalcards{T<:Union{Char}}(ranks::T...; take = 5)
  return foldl( (x,y) -> 100*x + y, indexin([ranks...][1:min(end, take)], collect(RANKS)))
end

function evalcards() return 0 end

function orderhand!(hand::Hand)
  sort!(hand.cards
    , lt = (x,y) -> begin
      findlast(RANKS, first(x))*10 + findlast(SUITS, last(x)) <
      findlast(RANKS, first(y))*10 + findlast(SUITS, last(y))
    end)
  return hand
end


function findstraight(hand::Hand)
  @assert length(hand.cards) >= 5 """cannot evaluate straights with less than 5 cards"""

  # hands already have the cards ordered
  oranks = unique(map(first, hand.cards))
  last(oranks) == 'A' && unshift!(oranks, 'A') # create that wrap

  ind = 1:(length(oranks)-4)
  contigs = map(i -> string(oranks[i:i+4]...), ind)
  filter!(c -> contains(RANKS, c), contigs) # RANKS is already ordered
  length(contigs) == 0 && return nothing
  sort!(contigs
    , lt = (x,y) ->
      findlast(collect(RANKS), last(x)) < findlast(collect(RANKS), last(y))
    , rev=true)

  # return the cards that belong in the largest straight
  return Hand(filter(c -> in(first(c), first(contigs)), hand.cards))
end


function tally(arr::AbstractArray)
  d = countmap(arr)
  collect(zip(keys(d), values(d)))
end

function findflush(hand::Hand)
  ranks = map(first, hand.cards)
  suits = map(last, hand.cards)

  # there can be at most 3 unique suits for a flush
  # to be present
  length(unique(suits)) > 3 && return nothing

  tallied = sort(tally(suits), lt = (x,y) -> x[2] < y[2], rev=true)

  tallied[1][2] < 5 && return nothing

  flush_suit = tallied[1][1]
  return Hand(filter(c -> last(c) == flush_suit, hand.cards))
end

function evaluate(hand::Hand)
  @assert length(hand.cards) == 7 """hands must contain 2 hole cards and 5 community cards"""

  # 900-999 straight flush
  # 800-899 quads
  # 700-799 full house
  # 600-699 flush
  # 500-599 straights
  # 400-499 trips
  # 300-399 two pair
  # 200-299 one pair
  # 100-199 hi card

  # STRAIGHT FLUSH
  flush = findflush(hand)
  if flush != nothing
    straight = findstraight(flush)
  end

  if flush != nothing && straight != nothing
    return round(900 + evalcards(last(straight.cards)[1]), 8)
  end

  ranks = map(first, hand.cards)
  counts = tally(ranks)
  sort!(counts, lt = (x,y) -> x[2]*100 + evalcards(x[1]) < y[2]*100 + evalcards(y[1]), rev=true)

  # QUADS
  if counts[1][2] >= 4
    return round(800 + evalcards(map(first, counts[1:2])...) / 10.0^2, 8)
  end

  # FULL HOUSE
  if counts[1][2] == 3 && counts[2][2] >= 2
    return round(700 + evalcards(map(first, counts[1:2])...) / 10.0^2, 8)
  end

  # FLUSH
  flush != nothing && return round(600 + evalcards(last(flush.cards)[1]), 8)

  # STRAIGHT
  straight = findstraight(hand)
  straight != nothing && return round(500 + evalcards(last(straight.cards)[1]), 8)

  # TRIPS
  if counts[1][2] == 3
    return round(400 + evalcards(map(first, counts[1:3])...) / 10.0^4, 8)
  end

  # TWO PAIR
  if counts[1][2] == 2 && counts[2][2] == 2
    return round(300 + evalcards(map(first, counts[1:3])...) / 10.0^4, 8)
  end

  # PAIR
  if counts[1][2] == 2
    return round(200 + evalcards(map(first, counts[1:4])...) / 10.0^6, 8)
  end

  return round(100 + evalcards(map(first, counts[1:5])...) / 10.0^8, 8)
end