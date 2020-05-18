##
# An adapter class to handle the difference between PUL's opinions on metadata
# and CC's "open world" assumptions. IE the date_created field is single-valued
# in MARC records, but multi-valued in Curation Concerns.
class RemoteRecord < SimpleDelegator
  class << self
    def retrieve(id)
      if id.present? && bibdata?(id)
        # FIXME: below will always raise an Argument error -- but this action
        # should also be short-cutted by raising the Bibdata error earlier, so
        # this is probably vestigial at this point
        result = new(IuMetadata::Client.retrieve(id))
        raise JSONLDRecord::MissingRemoteRecordError if result.source.blank?
        result
      else
        Null.retrieve(id)
      end
    end

    def bibdata?(source_metadata_identifier)
      IuMetadata::Client.bibdata?(source_metadata_identifier)
    end

    def bibdata_error_message
      IuMetadata::Client::BIBDATA_ERROR_MESSAGE
    end
  end

  # Null class.
  class Null
    include Singleton
    class << self
      def retrieve(_id)
        instance
      end
    end

    def source
      nil
    end

    def attributes
      {}
    end

    def raw_attributes
      {}
    end
  end

  class BibdataError < StandardError; end
end
