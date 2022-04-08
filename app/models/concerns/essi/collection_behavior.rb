module ESSI
  module CollectionBehavior
    extend ActiveSupport::Concern
    included do
      before_save :set_num_descendants
      property :num_collections, predicate: ::RDF::URI.new('http://dlib.indiana.edu/vocabulary/numCollections'), multiple: false
      property :num_works, predicate: ::RDF::URI.new('http://dlib.indiana.edu/vocabulary/numWorks'), multiple: false
    end

    def set_num_descendants
      self.num_collections = self.subtree_collection_ids.count
      self.num_works = self.subtree_work_ids.count
    end

    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      # POST to avoid URI Too Long error from solr, and raise row limit
      def child_objects_for(id, models: [])
        return [] if id.empty?
        conditions = { nesting_collection__parent_ids_ssim: id }
        models = Array.wrap(models).map(&:to_s)
        conditions[:has_model_ssim] = models if models.any?
        options = { method: :post, rows: 100_000 }
        ActiveFedora::Base.search_with_conditions(conditions, options)
      end
    
      def child_collections_for(id)
        child_objects_for(id, models: ['Collection'])
      end
    
      def child_works_for(id)
        child_objects_for(id, models: Hyrax.config.registered_curation_concern_types)
      end

      def subtree_objects_for(id, models: [])
        accrued = []
        nested = child_objects_for(id, models: models)
        while nested.any?
          accrued += nested
          collection_ids = nested.select { |e| Array.wrap(e['has_model_ssim']).include?'Collection' }.map(&:id)
          nested = child_objects_for(collection_ids, models: models)
        end
        accrued
      end

      def subtree_collections_for(id)
        subtree_objects_for(id, models: Collection)
      end

      def subtree_works_for(id)
        subtree_objects_for(id).select do |object|
          (object['has_model_ssim'] & Hyrax.config.registered_curation_concern_types).any?
        end
      end

      def tree_objects_for(id, models: [])
        ActiveFedora::Base.search_with_conditions({id: id}, rows: 1) + 
          subtree_objects_for(id, models: models)
      end

      def tree_collections_for(id)
        tree_objects_for(id, models: Collection)
      end
    end

    ClassMethods.public_instance_methods.each do |class_method|
      # child_objects, child_collections, etc.
      object_method = class_method.to_s.sub(/_for$/, '')
      define_method object_method do
        self.class.send(class_method, id)
      end

      # child_object_ids, child_collection_ids, etc.
      id_method = class_method.to_s.sub(/s_for$/, '_ids')
      define_method id_method do
        self.class.send(class_method, id).map(&:id)
      end
    end
  end
end
