# frozen_string_literal: true

require 'rails_helper'

module Bulkrax
  RSpec.describe ObjectFactory, type: :model do
    let(:attributes) { {} }
    let(:unique_identifier) { 'unique_identifier' }
    let(:replace_files) { false }
    let(:user) { FactoryBot.build(:user) }
    let(:klass) { Image }
    subject(:object_factory) { described_class.new(attributes, unique_identifier, replace_files, user, klass) }

    describe '#permitted_attributes' do
      it 'includes all importer form fields' do
        form_fields = [:admin_set_id, :rights_statement, :visibility]
        expect(object_factory.permitted_attributes).to include(*form_fields)
      end
      it 'includes ESSI structure map' do
        expect(object_factory.permitted_attributes).to include(:structure)
      end
    end

    xit '#work_actor' do
      # TODO: test override for ESSI::Actors::PerformLaterActor
    end
  end
end
