require 'rails_helper'

describe ApplicationHelper do
  describe '#display_for(:role)' do
    let(:user) { FactoryBot.build(:admin) }
    let(:edit_role) { Role.where(name: 'editor').first_or_create }
    let(:admin_role) { Role.where(name: 'admin').first_or_create }
    before do
      assign(:user, user)
      assign(:edit_role, edit_role)
      assign(:admin_role, admin_role)
    end
    context 'when the current user has the role' do
      it 'displays the content' do
        allow(user).to receive(:roles) { [admin_role, edit_role] }
        allow(helper).to receive(:current_user).and_return(user)
        content = helper.display_for('admin') { 'content' }
        expect(content).to eq('content')
      end
    end
    context 'when the current user does not have the role' do
      it 'does not display content' do
        edit_role = Role.where(name: 'editor').first_or_create
        allow(user).to receive(:roles) { [edit_role] }
        allow(helper).to receive(:current_user).and_return(user)
        content = helper.display_for('admin') { 'content' }
        expect(content).to eq(nil)
      end
    end
  end

  describe '#dynamic_hint(key)' do
    context 'without a dynamic_schema_service' do
      it 'returns nil' do
        expect(dynamic_hint(:key)).to be_nil
      end
    end
    context 'with a dynamic_schema_service' do
      context 'with a blank lookup result' do
        let(:dynamic_schema_service) { double('Dynamic Schema Service', property_locale: '') }
        it 'returns nil' do
          expect(dynamic_hint(:key)).to be_nil
        end
      end
      context 'with a redundant lookup result' do
        let(:dynamic_schema_service) { double('Dynamic Schema Service', property_locale: 'Key') }
        it 'returns nil' do
          expect(dynamic_hint(:key)).to be_nil
        end
      end
      context 'with a valid lookup result' do
        let(:dynamic_schema_service) { double('Dynamic Schema Service', property_locale: 'Real help text') }
        it 'returns nil' do
          expect(dynamic_hint(:key)).to eq 'Real help text'
        end
      end
    end
  end

  describe '#dynamic_label(key)' do
    context 'without a dynamic_schema_service' do
      it 'returns nil' do
        expect(dynamic_label(:key)).to be_nil
      end
    end
    context 'with a dynamic_schema_service' do
      context 'with a blank lookup result' do
        let(:dynamic_schema_service) { double('Dynamic Schema Service', property_locale: '') }
        it 'returns nil' do
          expect(dynamic_label(:key)).to be_nil
        end
      end
      context 'with a lookup result' do
        let(:dynamic_schema_service) { double('Dynamic Schema Service', property_locale: 'Key') }
        it 'returns nil' do
          expect(dynamic_label(:key)).to eq 'Key'
        end
      end
    end
  end
end
