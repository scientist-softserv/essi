module Qa::Authorities
  class IucatLibraries < Base
    include WebServiceBase

    def search(id)
      all.select { |library| library[:code].match(id.to_s) }
    end

    def find(id)
      api_data_for(id)[:library] || supplemental_data_for(id) || {}
    end

    def all
      ((api_data_for('all')[:libraries] || []) + supplemental_data).uniq { |r| r[:code] }
    end

    private
      def api_url(id)
        return nil unless ESSI.config[:iucat_libraries]
        [ESSI.config[:iucat_libraries][:url], ::Addressable::URI.escape(id)].join('/')
      end

      def api_data_for(id)
        return {} unless api_enabled? && api_url(id)
        begin
          result = json(api_url(id)).with_indifferent_access
          result[:success] ? filter_results(result[:data]) : {}
        rescue TypeError, JSON::ParserError, Faraday::ConnectionFailed, URI::InvalidURIError
          {}
        end
      end

      def api_enabled?
        return nil unless ESSI.config[:iucat_libraries]
        ESSI.config[:iucat_libraries][:api_enabled]
      end

      def filter_results(data)
        (data.dig(:libraries) || []).each do |library|
          data[:libraries].delete(library) if no_display?(library)
        end
        data
      end

      # counterintuitively, API no_display values of false equate to hidden from display
      # hide any libraries missing a label, regardless of no_display value
      def no_display?(library)
        library[:no_display].is_a?(FalseClass) || library[:label].blank?
      end

      def supplemental_data_for(id)
        supplemental_data.select { |e| e[:code] == id }.first
      end

      def supplemental_data
        data_path = Rails.root.join('config', 'authorities', 'supplemental_holding_locations.yml')
        @supplemental_data ||= begin
          YAML.load_file(data_path).map { |h| h.with_indifferent_access }
        rescue
          []
        end
      end
  end
end
