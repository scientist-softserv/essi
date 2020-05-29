class PurlController < ApplicationController
  def default
    set_object(WORK_LOOKUPS, split_id: true)
    respond_to do |f|
      f.html { redirect_to @url }
      f.json { render json: { url: @url }.to_json }
      f.iiif do
        @url = manifest_url(@url)
        @url.present? ? (redirect_to @url) : render_404
      end
    end
  end

  def formats
    set_object(FILESET_LOOKUPS, split_id: false)
    respond_to do |f|
      f.html { redirect_to @url }
      f.json { render json: { url: @url }.to_json }
      f.jp2 do
        @url = jp2_url(@solr_hit)
        @url.present? ? (redirect_to @url) : render_404
      end
    end
  end

  private
    FILESET_LOOKUPS = { FileSet => nil }.freeze
    # FIXME: refactor?
    WORK_LOOKUPS = {
      BibRecord => /^\w{3}\d{4}$/,
      Image => /^\w{3,}\d{4,}$/,
      PagedResource => /^\w{3}\d{4}$/,
      Scientific => /^\w{3}\d{4}$/,
    }.freeze
   
    # sets @solr_hit (if found), @url (always)
    def set_object(lookup_rules, split_id: false)
      id, volume, page = (split_id ? params[:id].split('-') : params[:id] )
      volume = normalize_number(volume)
      page = normalize_number(page)
      lookup_rules.each do |klass, match_pattern|
        @solr_hit = find_object(id, klass, match_pattern)
        @url = object_url(klass, volume, page, @solr_hit) if @solr_hit
        break if @solr_hit
      end
      @url ||= rescue_url
    end

    def find_object(id, klass, match_pattern)
      if match_pattern.nil? || id.match(match_pattern)
        klass.search_with_conditions(
          { source_metadata_identifier_tesim: id }, rows: 1
        ).first
      end
    end

    def object_url(klass, volume, page, solr_hit)
      begin
        subfolder = klass.to_s.pluralize.underscore
        url = "#{request.protocol}#{request.host_with_port}" \
          "#{config.relative_url_root}/concern/#{subfolder}/#{solr_hit.id}"
        url += "#?m=#{volume}&cv=#{page}" if volume.positive? || page.positive?
      rescue StandardError
        url = rescue_url
      end
      url
    end

    def rescue_url
      @rescue_url ||= ESSI.config.dig(:essi, :purl_redirect_url) % params[:id]
    end

    def jp2_url(solr_hit)
      begin
        Hyrax.config.iiif_image_url_builder.call(solr_hit['original_file_id_ssi'], nil, '!600,600')
      rescue StandardError
        nil
      end
    end

    def manifest_url(url)
      if url == rescue_url
        nil
      else
        url = url + '/manifest'
      end
    end

    def render_404
      render plain: 'File not found', status: :not_found
    end

    def normalize_number(n)
      [n.to_i - 1, 0].max
    end
end
