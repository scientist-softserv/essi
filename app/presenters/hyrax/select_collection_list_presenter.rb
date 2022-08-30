module Hyrax
  # Presents the list of collection options available to a user
  class SelectCollectionListPresenter
    # @param current_ability [Ability]
    def initialize(current_ability)
      @current_ability = current_ability
    end

    class_attribute :row_presenter
    self.row_presenter = CollectionPresenter

    # @return [Boolean] are there many different collections to choose?
    def many?
      authorized_collection_ids.size > 1
    end

    # @return [Boolean] are there any authorized collections?
    def any?
      authorized_collection_ids.present?
    end

    # @return [Array<CollectionPresenter>] array of collection presenters
    def authorized_collections
      @authorized_collections ||= authorized_collection_docs.map { |doc| row_presenter.new(doc, @current_ability) }
    end

    # @return [Array<SolrDocument>] array of solr documents for each collection
    # query_limit prevents exceeding the solr query header max
    def authorized_collection_docs
      query_limit = 100
      @authorized_collection_docs ||= authorized_collection_ids.each_slice(query_limit).inject([]) do |acc, slice|
        acc + Collection.search_with_conditions({ id: slice}, rows: query_limit).map { |doc| ::SolrDocument.new(doc) }
      end
    end

    # @return [Array<String>] array of collection ids
    def authorized_collection_ids
      @authorized_collection_ids ||= Hyrax::Collections::PermissionsService.collection_ids_for_deposit(ability: @current_ability)
    end

    # @yieldparam [CollectionPresenter] a presenter for the collection
    def each
      authorized_collection_docs.each { |doc| yield row_presenter.new(doc, @current_ability) }
    end

    def options_for_select
      options = []
      self.each { |r| options << [r.to_s, r.id] }
      options.sort
    end
  end
end
