# Makes campus logo available to Collections, Works, and FileSets.
module Extensions
  module Hyrax
    module FileSetPresenter
      module CampusLogo
        def campus_logo
          return false unless parent
          # Check if campus information is set for file set's work's admin set
          set = parent.admin_set.first.parameterize(separator: '_')
          return false unless ESSI.config[:essi][:campus_logos].present? && ESSI.config[:essi][:campus_logos][set]

          title = ESSI.config[:essi][:campus_logos][set][:title]
          link = ESSI.config[:essi][:campus_logos][set][:url]
          "<a href='#{link}'>#{title}</a>".html_safe
        end
      end
    end
  end
end
