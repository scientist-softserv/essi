# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe Importer, type: :model do
    let(:importer) do
      FactoryBot.build(:bulkrax_importer_mets_xml)
    end
    let(:current_run) do
      FactoryBot.build(:bulkrax_importer_run, importer: importer)
    end
    let(:importer_runs) do
      FactoryBot.build_list(:bulkrax_importer_run, 2, importer: importer)
    end

    describe '#last_run', :clean do
      context 'with importer_runs' do
        before do
          allow(importer).to receive(:importer_runs).and_return(importer_runs)
        end
        it 'returns importer_runs.last' do
          expect(importer.last_run).to eq importer_runs.last
        end
      end
      context 'without importer_runs' do
        before do
          allow(importer).to receive(:importer_runs).and_return(Bulkrax::ImporterRun.none)
          allow(importer).to receive(:current_run).and_return(current_run)
        end
        it 'returns current_run' do
          expect(importer.last_run).to eq importer.current_run
        end
      end
    end
  end
end
