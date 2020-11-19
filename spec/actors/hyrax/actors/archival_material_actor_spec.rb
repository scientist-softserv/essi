# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
require 'spec_helper'
require 'rails_helper'

RSpec.describe Hyrax::Actors::ArchivalMaterialActor do
  let(:work) { FactoryBot.create(:archival_material_with_one_image) }
  let(:ability) { ::Ability.new(user) }
  let(:env) { Hyrax::Actors::Environment.new(work, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:user)     { FactoryBot.create(:user) }
  let(:attributes) { {} }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  describe "#create" do
    context 'when index_ocr_files is true', :clean do
      it 'OCR should be searchable' do
        allow(ESSI.config).to receive(:dig) \
        .with(any_args).and_call_original
        allow(ESSI.config).to receive(:dig) \
        .with(:essi, :index_ocr_files) \
        .and_return(true)
        expect { middleware.create(env) }.to change { work.ocr_state }.from(nil).to("searchable")
      end
    end

    context 'when index_ocr_files is false', :clean do
      it 'OCR should not be searchable' do
        allow(ESSI.config).to receive(:dig) \
        .with(any_args).and_call_original
        allow(ESSI.config).to receive(:dig) \
        .with(:essi, :index_ocr_files) \
        .and_return(false)
        expect { middleware.create(env) }.not_to change { work.ocr_state }
      end
    end
  end
end
