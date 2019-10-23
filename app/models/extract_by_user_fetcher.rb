class ExtractByUserFetcher < FetcherBase
  def extracts(query, extract_ids)
    return Extract.none if query.fetch(:user_id, nil).blank?

    user_extracts_query = query.except(:subject_id)
    if fetch_minimal?
      @minimal_user_extracts ||= Extract.where(user_extracts_query.merge(id: @extract_ids))
    else
      @maximal_user_extracts ||= Extract.where(user_extracts_query)
    end
  end
end
