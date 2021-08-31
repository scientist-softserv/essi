# Refactor as custom actor
class IngestYAMLJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  # @param [File] yaml_file
  # @param [User] user
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(yaml_file, user, opts = {})
    logger.info "Ingesting YAML #{yaml_file}"
    @yaml_file = yaml_file
    @yaml = File.open(yaml_file) { |f| Psych.load(f) }
    @user = user
    @file_association_method = opts[:file_association_method] || :batch
    ingest
  end

  private
    def ingest
      actor.create(actor_environment)
    end

    def actor
      @actor ||= Hyrax::CurationConcern.actor
    end

    def actor_environment
      Hyrax::Actors::Environment.new(curation_concern, current_ability, attributes_for_actor)
    end

    def curation_concern
      @curation_concern ||= @yaml[:resource].constantize.new
    end

    def current_ability
      @current_ability ||= Ability.new(@user)
    end

    def attributes_for_actor
      attributes = {}
      if @yaml[:attributes].present?
        @yaml[:attributes].each_value do |yaml_attributes_set|
          attributes.merge!(yaml_attributes_set)
        end
      end
      attributes[:source_metadata] = @yaml[:source_metadata] if @yaml[:source_metadata].present?
      attributes[:remote_files] = files_for_actor
      attributes[:structure] = @yaml[:structure].deep_symbolize_keys if @yaml[:structure].present?
      # TODO: user thumbnail_path, collections, sources
      attributes
    end

    def files_for_actor
      files = @yaml[:files]
      files.each do |file|
        file[:url] = 'file://' + Rails.root.join(file[:path]).to_s
      end
      files
    end
end
