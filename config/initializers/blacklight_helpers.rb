Blacklight::UrlHelperBehavior.module_eval do
  # modified from blacklight wih the new #add_highlight_url
  # link_to_document(doc, 'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a hash. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  # TODO: move this to the IndexPresenter
  def link_to_document(doc, field_or_opts = nil, opts = { counter: nil })
    if field_or_opts.is_a? Hash
      opts = field_or_opts
    else
      field = field_or_opts
    end

    field ||= document_show_link_field(doc)
    label = index_presenter(doc).label field, opts
    # Pass search on to item view.
    url = add_highlight_url(doc)
    link_to label, url, document_link_params(doc, opts)
  end

  # Adds search term to be highlighed on item to catalog search URL
  #
  # @param [Object] SolrDocument
  # @return <Array(ActionDispatch::Routing::RoutesProxy, SolrDocument)> if no highlight parameter added
  # @return <Array(ActionDispatch::Routing::RoutesProxy, SolrDocument, Hash)> if highlight parameter added
  def add_highlight_url(doc)
    modified_url = url_for_document(doc)
    modified_url += [{ query: params['q'] }] if params['q'].present?
    modified_url
  end
end
