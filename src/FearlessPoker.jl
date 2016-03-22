module FearlessPoker
using FearlessSQL, StatsBase, Memoize

# types to export
export Hand

export RANKS, SUITS, DECK, STARTING_HANDS

# functions to export
export evaluate, equity


# package code goes here
# source all the separate files
srcdir = dirname(@__FILE__)
srcfiles = setdiff(readdir(srcdir), [basename(@__FILE__)])
map(include, srcfiles)

end # module
