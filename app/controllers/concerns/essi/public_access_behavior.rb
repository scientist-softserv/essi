module Essi
  module PublicAccessBehavior
    extend ActiveSupport::Concern

    # When access_only mode is enabled, denies access to the controller and action combinations listed in the :deny section below.
    # Definitions can be provided as regular expression or strings (which are compared using starts_with?)
    # Access to a denied controller or action can be reinstated by providing a more specific entry in the :allow section.
    
    DENY_PUBLIC_ACCESS = { allow: ['hyrax/admin/stats',
                                   'hyrax/dashboard/profiles',
                                   'hyrax/pages#show',
                           ],
                           deny: [%r{^hyrax/    # Free space regexp to deny resource modification actions
                                     (file_sets|images|paged_resources|bib_records|archival_materials|scientifics)    # Resource controllers to deny
                                     [#]    # Character class wrapped delimiter
                                     (new|create|edit|update|destroy|save_structure|regenerate_ocr)    # Actions to deny on resource controllers
                                   }x,
                                  'allinson_flex',
                                  'bulkrax',
                                  'hyrax/admin',
                                  'hyrax/batch_edits',
                                  'hyrax/content_blocks',
                                  'hyrax/dashboard',
                                  'hyrax/depositors',
                                  'hyrax/embargoes',
                                  'hyrax/leases',
                                  'hyrax/my',
                                  'hyrax/pages',
                                  'hyrax/transfers',
                                  'hyrax/uploads',
                           ] }

    included do
      before_action :check_public_access
    end

    def check_public_access
      return unless helpers.access_only?
      @access_path_action = "#{controller_path}##{action_name}"
      if match_access_list(DENY_PUBLIC_ACCESS[:deny]) && !match_access_list(DENY_PUBLIC_ACCESS[:allow])
        flash[:error] = "The requested action (#{@access_path_action}) is not available on this site."
        redirect_to('/', status: 302)
      end
    end

    private

    def match_access_list(list)
      list.any? do |deny|
        case deny
        when String
          @access_path_action.starts_with? deny
        when Regexp
          deny === @access_path_action
        end
      end
    end
  end
end
