module Qa::Authorities
  class IucatLibraries < Base
    include WebServiceBase

    def search(id)
      all.select { |library| library[:code].match(id.to_s) }
    end

    def find(id)
      data_for(id)[:library] || {}
    end

    def all
      data_for('all')[:libraries] || []
    end

    private
      def api_url(id)
        return nil unless ESSI.config[:iucat_libraries]
        [ESSI.config[:iucat_libraries][:url], ERB::Util.url_encode(id)].join('/')
      end

      def data_for(id)
        return {} unless api_enabled? && api_url(id)
        begin
          result = json(api_url(id)).with_indifferent_access
          result[:success] ? result[:data] : {}
        rescue TypeError, JSON::ParserError, Faraday::ConnectionFailed, URI::InvalidURIError
          {}
        end
      end

      def api_enabled?
        return nil unless ESSI.config[:iucat_libraries]
        ESSI.config[:iucat_libraries][:api_enabled]
      end
  end
end
