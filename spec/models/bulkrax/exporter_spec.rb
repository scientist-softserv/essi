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

    describe '#mapping', :clean do
      context 'without a field_mapping' do
        before do
          allow(exporter).to receive(:field_mapping).and_return(nil)
        end
        it 'returns default_mapping' do
          expect(exporter.mapping).to eq exporter.default_mapping
        end
      end
      context 'with a field_mapping' do
        before do
          allow(exporter).to receive(:field_mapping).and_return({ test: { from:['test'] } })
        end
        it 'merges field_mapping into default_mapping' do
          expect(exporter.mapping.keys).to include('test')
        end
      end
    end
  
    describe '#default_mapping' do
      it 'returns a configuration for each export field' do
        expect(exporter.default_mapping.size).to eq exporter.export_properties.size
        expect(exporter.default_mapping.values.all?(ActiveSupport::HashWithIndifferentAccess)).to eq true
      end
    end
  end
end
