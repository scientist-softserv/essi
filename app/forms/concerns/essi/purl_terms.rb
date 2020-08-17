module ESSI
  module PurlTerms
    extend ActiveSupport::Concern
    included do
      self.terms += [:purl]
    end
  end
end
