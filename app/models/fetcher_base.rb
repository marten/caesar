class FetcherBase
  STRATEGIES = [ :fetch_all, :fetch_minimal ]

  attr_reader :strategy

  def initialize(strategy = :fetch_all)
    @strategy = strategy
  end

  def fetch_minimal?
    @strategy == :fetch_minimal
  end
end