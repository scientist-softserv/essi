module Extensions
  module ActiveFedora
    module File
      module EscapingObsoletions
        # modified from active_fedora: replace obsolete URI.escape method calls with Addressable::URI.escape
        def ldp_headers
          headers = { 'Content-Type'.freeze => mime_type, 'Content-Length'.freeze => content.size.to_s }
          headers['Content-Disposition'.freeze] = "attachment; filename=\"#{::Addressable::URI.escape(@original_name)}\"" if @original_name
          headers
        end
      end
    end
  end
end

