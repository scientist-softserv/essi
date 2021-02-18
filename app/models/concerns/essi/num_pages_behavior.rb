module ESSI
  module NumPagesBehavior
    extend ActiveSupport::Concern
    included do
      before_save :set_num_pages
    end

    private

      def set_num_pages
        self.num_pages = pages_bucket(100)
      end

      def pages
        self.member_ids.size
      end

      def pages_bucket(size)
        n = (pages.to_i / size) * size
        "#{n}-#{n + size - 1} pages"
      end
  end
end
