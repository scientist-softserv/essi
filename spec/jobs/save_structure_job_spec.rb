# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe SaveStructureJob do # rubocop:disable Metrics/BlockLength
  let(:paged_resource) { create(:paged_resource_with_one_image) }
  let(:structure)      { build_structure }

  describe '#perform' do
    it 'saves the structure successfully' do
      expect(paged_resource.logical_order.order).to be_empty

      described_class.perform_now(paged_resource, structure)

      expect(paged_resource.logical_order.order).to_not be_empty
      expect(paged_resource.logical_order.order['label']).to eq('logical')
      expect(paged_resource.logical_order.order.dig('nodes').first.dig('label'))
        .to eq('Main')
      expect(paged_resource.logical_order.order.to_s)
        .to include(paged_resource.file_set_ids.first.to_s)
    end
  end

  def build_structure # rubocop:disable Metrics/MethodLength
    {
      'label': 'logical',
      'nodes': [
        {
          'label': 'Main',
          'nodes': [
            {
              'proxy': paged_resource.file_set_ids.first.to_s
            }
          ]
        }
      ]
    }.to_json
  end
end
