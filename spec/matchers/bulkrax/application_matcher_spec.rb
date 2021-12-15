# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe ApplicationMatcher, type: :model do
    let(:matcher) { described_class.new(split: true) }

    describe '#parse_subject' do
      let(:test_string) { 'Old Water Tower (Chicago, Ill.)|Towers|Historic buildings|Domes|Finials|Courtyards|Buildings|Chimneypieces|Arches' }

      it 'refrains from changing string case' do
        expect(matcher.parse_subject(test_string)).to eq test_string
      end
    end
  end
end
