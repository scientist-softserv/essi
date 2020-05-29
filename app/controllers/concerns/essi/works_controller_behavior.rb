module ESSI
  module WorksControllerBehavior

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
  
      json = sanitize_manifest(JSON.parse(manifest_builder))
  
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
  
    private
      def after_create_response
        # Calling `#t` in a controller context does not mark _html keys as html_safe
        flash[:notice] = view_context.t('hyrax.works.create.after_create_html', application_name: view_context.application_name)
        redirect_to hyrax.my_works_path
      end

      def sanitize_manifest(hash)
        hash['label'] = sanitize_value(hash['label']) if hash.key?('label')
        hash['description'] = hash['description']&.collect { |elem| sanitize_value(elem) } if hash.key?('description')
  
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
