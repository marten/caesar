class Workflow::ConvertLegacyReducersConfig
  attr_reader :workflow

  def initialize(workflow)
    @workflow = workflow
  end

  def update(config)
    return if config.nil?

    workflow.reducers.where.not(key: config.keys).delete_all

    config.each do |key, config|
      reducer = workflow.reducers.find_by(key: key)
      reducer ||= reducer_type(config).new(workflow: workflow, key: key)
      reducer.config = config.except("filters", "grouping", "group_by", "type")
      reducer.grouping = config["group_by"] || config["grouping"] || nil
      reducer.filters = config["filters"] || {}
      reducer.save!
    end
  end

  def reducer_type(config)
    case config["type"].to_s
    when "count"
      Reducers::CountReducer
    when "external"
      Reducers::ExternalReducer
    when "stats"
      Reducers::StatsReducer
    when "consensus"
      Reducers::ConsensusReducer
    when "unique_count"
      Reducers::UniqueCountReducer
    else
      raise "Reducer misconfigured: unknown type #{config["type"]}"
    end
  end
end