require 'spec_helper'

describe Reducers::ConsensusReducer do
  subject(:reducer) { described_class.new("s") }

  def build_extracts(choices)
    choices.map.with_index do |choice, idx|
      vals = Array.wrap(choice)
      data = vals.map { |val| {val => 1} }.reduce(:merge)

      Extract.new(
        classification_id: idx,
        classification_at: Date.new(2017, 2, 6),
        data: data
      )
    end
  end

  describe '#process' do
    it 'processes when there are no classifications' do
      expect(reducer.process([])).to eq({})
    end

    it 'returns the most likely' do
      extracts = build_extracts(["ZEBRA", "ZEBRA", "ZEBRA", ["ZEBRA", "BIRD"]])
      expect(reducer.process(extracts))
        .to include({"most_likely" => "ZEBRA", "agreement" => 0.75})
    end

    it 'handles multiple species' do
      extracts = build_extracts([["ZEBRA", "BIRD"], ["ZEBRA", "BIRD"]])
      expect(reducer.process(extracts))
        .to include({"most_likely" => "BIRD+ZEBRA", "agreement" => 1.0})

    end
  end
end