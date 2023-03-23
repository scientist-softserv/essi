module ESSI
  module WorksControllerBehavior
    # @todo review after upgrade to Hyrax 3.x
    def self.included(base)
      base.class_eval do
        # hyrax claims the presenter handles authorization
        # in practice, it generates a ruby error
        load_and_authorize_resource only: :file_manager
      end
    end

    def additional_response_formats(wants)
      wants.uv do
        presenter && parent_presenter
        render 'viewer_only.html.erb', layout: 'boilerplate', content_type: 'text/html'
      end
      # Allow kaminari gem to paginate child items using ajax
      wants.js do
        render :show
      end
    end

    # Overrides stock Hyrax method to accept retrieving a cached JSON manifest_builder
    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      # manifest builder is now being handled in the IIIF Print gem
      json = iiif_manifest_builder.manifest_for(presenter: presenter)

      respond_to do |wants|
        wants.json { render json: json }
        wants.html { render json: json }
      end
    end

    # Overrides stock Hyrax manifest_builder to cache as JSON
    def manifest_builder
      Rails.cache.fetch("manifest/#{presenter.id}/#{ResourceIdentifier.new(presenter.id)}") do
        ::IIIFManifest::ManifestFactory.new(presenter).to_h.to_json
      end
    end

    # Overrides stock Hyrax method to catch AllinsonFlex errors during build_form
    def new
      begin
        super
      rescue ::AllinsonFlex::NoAllinsonFlexContextError, ::AllinsonFlex::NoAllinsonFlexSchemaError => e
        redirect_to my_works_path, alert: 'Error retrieving AllinsonFlex properties.  A new profile version may still be saving.'
      end
    end

    private
      def after_create_response
        # Calling `#t` in a controller context does not mark _html keys as html_safe
        flash[:notice] = view_context.t('hyrax.works.create.after_create_html', application_name: view_context.application_name)
        redirect_to hyrax.my_works_path
      end

      def sanitize_manifest(hash)
        hash['label'] = sanitize_value(hash['label']) if hash.key?('label')
        hash['description'] = Array.wrap(hash['description']).collect { |elem| sanitize_value(elem) } if hash.key?('description')

        hash['sequences']&.each do |sequence|
          sequence['canvases']&.each do |canvas|
            canvas['label'] = sanitize_value(canvas['label'])
          end
        end
        hash
      end

      def sanitize_value(text)
        Loofah.fragment(text.to_s).scrub!(:prune).to_s
      end
  end
end
