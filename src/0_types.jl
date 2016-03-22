type Hand
  cards::Array{AbstractString}

  function Hand(h::Array)
    @assert length(unique(h)) == length(h) """a hand cannot contain duplicate cards"""
    @assert length(setdiff(h, DECK)) == 0 """hand contains invalid cards"""
    return orderhand!(new(h))
  end
end

function Hand(h::AbstractString)
  return Hand(split(h, ","))
end

function Hand(h::Integer)
  idx = find(n -> in(n, keys(factor(h))), primes(239))
  return Hand(DECK[idx])
end

function Base.convert(::Type{Integer}, h::Hand)
  # first 52 primes
  p = primes(239)
  idx = find(card -> in(card, h.cards), DECK)
  return prod(p[idx])
end

Base.convert(::Type{AbstractString}, h::Hand) = join(h.cards, ",")

Base.hash(hand::Hand) = hash(hand.cards)

Base.isequal{T<:Hand}(x::T, y::T) = hash(x) == hash(y)

Base.(:(==)){T<:Hand}(x::T, y::T) = hash(x) == hash(y)