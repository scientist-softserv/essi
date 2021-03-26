# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe Exporter, type: :model do
    let(:exporter) do
      FactoryBot.build(:bulkrax_exporter)
    end
    let(:current_run) do
      FactoryBot.build(:bulkrax_exporter_run, exporter: exporter)
    end
    let(:exporter_runs) do
      FactoryBot.build_list(:bulkrax_exporter_run, 2, exporter: exporter)
    end

    describe '#last_run', :clean do
      context 'with exporter_runs' do
        before do
          allow(exporter).to receive(:exporter_runs).and_return(exporter_runs)
        end
        it 'returns exporter_runs.last' do
          expect(exporter.last_run).to eq exporter_runs.last
        end
      end
      context 'without exporter_runs' do
        before do
          allow(exporter).to receive(:exporter_runs).and_return(Bulkrax::ExporterRun.none)
          allow(exporter).to receive(:current_run).and_return(current_run)
        end
        it 'returns current_run' do
          expect(exporter.last_run).to eq exporter.current_run
        end
      end
    end
  end
end
