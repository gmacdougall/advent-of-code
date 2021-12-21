#! /usr/bin/env ruby
# frozen_string_literal: true

space = ARGF.map { _1.split.last.to_i }

DIE_RESULTS = [1, 2, 3].to_a.product([1, 2, 3], [1, 2, 3]).map(&:sum).tally.freeze

wins = [0, 0]

game_states = [
  {
    0 => { score: 0, space: space[0] },
    1 => { score: 0, space: space[1] },
    count: 1,
  }
]

player = 0
while game_states.any?
  opp = (player + 1) % 2
  new_game_states = {}
  game_states.each do |poss|
    DIE_RESULTS.each do |k, v|
      new_space = ((k + poss[player][:space] - 1) % 10) + 1
      new_score = poss[player][:score] + new_space
      if new_score >= 21
        wins[player] += v * poss[:count]
      else
        key = (new_score * 1_000_000_000) + (new_space * 1_000_000) + (poss[opp][:score] * 1000) + poss[opp][:space]
        result = new_game_states[key]
        unless result
          result = {
            player => { score: new_score, space: new_space },
            opp => { score: poss[opp][:score], space: poss[opp][:space] },
            count: 0,
          }
          new_game_states[key] = result
        end
        result[:count] += v * poss[:count]
      end
    end
  end
  player = opp
  game_states = new_game_states.values
end

puts wins.max
