require Rails.root.join('lib', 'iu_metadata.rb')
require Rails.root.join('lib', 'iu_metadata', 'attribute_ingester.rb')
require Rails.root.join('lib', 'iu_metadata', 'client.rb')
require Rails.root.join('lib', 'iu_metadata', 'marc_record.rb')
require Rails.root.join('lib', 'iu_metadata', 'mets_record.rb')
require Rails.root.join('lib', 'iu_metadata', 'mods_record.rb')

module ESSI
  module RemoteMetadataLookupBehavior
    def attributes_for_actor
      if wants_to_update_remote_metadata?
        super.to_h.with_indifferent_access.merge(remote_attributes)
      else
        super
      end
    end

    def remote_attributes
      @remote_attributes ||= begin
         remote_attributes = remote_data.raw_attributes
         remote_attributes['source_metadata'] = remote_data.source.dup.try(:force_encoding, 'utf-8') if remote_data.source
         remote_attributes
      end
    end

    private
      def wants_to_update_remote_metadata?
        params[:action] == 'create' || params[:refresh_remote_metadata]
      end

      def source_metadata_identifier
        @source_metadata_identifier ||= params[hash_key_for_curation_concern]['source_metadata_identifier']
      end

      def remote_data
        @remote_data ||=
          remote_metadata_factory.retrieve(source_metadata_identifier)
      end

      def remote_metadata_factory
        if RemoteRecord.bibdata?(source_metadata_identifier)
          JSONLDRecord::Factory.new(curation_concern.class)
        elsif source_metadata_identifier.blank?
          RemoteRecord
        else
          flash[:alert] = I18n.t('services.remote_metadata.invalid_identifier').to_s + (I18n.t('services.remote_metadata.validation') || RemoteRecord.bibdata_error_message).to_s
          RemoteRecord
        end
    end
  end
end

