module Extensions
  module Hyrax
    module Forms
      module WorkForm
        module WorkMembersSpeedy
          # Use solr instead of fedora to lookup work members
          def work_members
            model.member_works
          end
        end
      end
    end
  end
end
