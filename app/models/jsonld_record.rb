class JSONLDRecord
  extend Forwardable
  class Factory
    attr_reader :factory
    def initialize(factory)
      @factory = factory
    end

    def retrieve(bib_id)
      marc = IuMetadata::Client.retrieve(bib_id, :marc)
      mods = IuMetadata::Client.retrieve(bib_id, :mods)
      raise MissingRemoteRecordError, 'No MARC record found for this ID' if
        marc.source.blank?
      raise MissingRemoteRecordError, 'No MODS record found for this ID' if
        mods.source.blank?
      JSONLDRecord.new(bib_id, marc, mods, factory: factory)
    end
  end

  class MissingRemoteRecordError < StandardError; end

  attr_reader :bib_id, :marc, :mods, :factory, :attribute_ingester
  def initialize(bib_id, marc, mods, factory: PagedResource)
    @bib_id = bib_id
    @marc = marc
    @mods = mods
    @factory = factory
    @attribute_ingester = IuMetadata::AttributeIngester.new(marc.id,
                                                            marc.attributes,
                                                            factory: factory)
  end

  def source
    marc_source
  end

  def_delegator :@marc, :source, :marc_source
  def_delegator :@mods, :source, :mods_source
  def_delegator :@attribute_ingester, :attributes, :attributes
  def_delegator :@attribute_ingester, :raw_attributes, :raw_attributes
end
