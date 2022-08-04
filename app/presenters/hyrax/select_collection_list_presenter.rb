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
      authorized_collections.size > 1
    end

    # @return [Boolean] are there any authorized collections?
    def any?
      return true if authorized_collections.present?
      false
    end

    # Return an array of authorized collections

    def authorized_collections
      @authorized_collections ||= Collection.search_with_conditions(id: authorized_collection_ids).map { |collection| ::SolrDocument.new(collection) }
    end

    def authorized_collection_ids
      @authorized_collection_ids ||= Hyrax::Collections::PermissionsService.collection_ids_for_deposit(ability: @current_ability)
    end

    # Return or yield the first type in the list. This is used when the list
    # only has a single element.
    # @yieldparam [CollectionType] a Hyrax::CollectionType
    # @return [CollectionType] a Hyrax::CollectionType
    def first_collection_type
      yield(authorized_collections.first) if block_given?
      authorized_collections.first
    end

    # @yieldparam [CollectionPresenter] a presenter for the collection
    def each
      authorized_collections.each { |collection| yield row_presenter.new(collection, @current_ability) }
    end

    def options_for_select
      options = []
      self.each { |r| options << [r.title.first, r.id] }
      options.sort
    end
  end
end
