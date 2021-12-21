#! /usr/bin/env ruby
# frozen_string_literal: true

space = ARGF.map { _1.split.last.to_i }

DIE_RESULTS = [1, 2, 3].to_a.product([1, 2, 3], [1, 2, 3]).map(&:sum).tally.freeze

wins = [0, 0]

game_states = [
  {
    p1_score: 0,
    p1_space: space[0],
    p2_score: 0,
    p2_space: space[1],
    count: 1,
  }
]

def generate(current_state, player_score, player_space, opponent_score, opponent_space)
  new_game_states = {}
  current_state.each do |poss|
    DIE_RESULTS.each do |k, v|
      new_space = ((k + poss[player_space]) % 10)
      new_space = 10 if new_space.zero?
      new_score = poss[player_score] + new_space
      key = (new_score * 1_000_000_000) + (new_space * 1_000_000) + (poss[opponent_score] * 1000) + poss[opponent_space]
      result = new_game_states[key]
      unless result
        result = {
          player_score => new_score,
          player_space => new_space,
          opponent_score => poss[opponent_score],
          opponent_space => poss[opponent_space],
          count: 0,
        }
        new_game_states[key] = result
      end
      result[:count] += v * poss[:count]
    end
  end
  new_game_states.values
end

while game_states.any?
  game_states = generate(game_states, :p1_score, :p1_space, :p2_score, :p2_space)
  wins[0] += game_states.select { _1[:p1_score] >= 21 }.sum { _1[:count] }
  game_states.reject! { _1[:p1_score] >= 21 }

  game_states = generate(game_states, :p2_score, :p2_space, :p1_score, :p1_space)
  wins[1] += game_states.select { _1[:p2_score] >= 21 }.sum { _1[:count] }
  game_states.reject! { _1[:p2_score] >= 21 }
end

puts wins.max
