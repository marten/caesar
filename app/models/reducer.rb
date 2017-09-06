class Reducer < ApplicationRecord
  belongs_to :workflow

  #     include Configurable

  NoData = Class.new

  #     attr_reader :key, :filters, :grouping

  #     def initialize(key, config = {})
  #       @key = key
  #       @filters = config["filters"] || {}
  #       @grouping = config["group_by"] || nil
  #       load_configuration(config)
  #     end

  def process(extracts)
    filtered_extracts = ExtractFilter.new(extracts, filters).to_a
    grouped_extracts = ExtractGrouping.new(filtered_extracts, grouping).to_h
    grouped_extracts.map do |key, grouped|
      [key, reduction_data_for(grouped)]
    end.to_h
  end

  def config
    super || {}
  end

  def grouping
    config["group_by"] || nil
  end

  def filters
    super || {}
  end

  #   end
  # end
end