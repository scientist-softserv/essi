module ESSI
  module OCRSearch

    def show
      super
      set_catalog_search_term_for_uv_search
    end

    def set_catalog_search_term_for_uv_search
      return unless params[:query].present?
      search_term = CGI::parse(params[:query])
      params[:highlight] = search_term&.flatten&.first
    end
  end
end
