require 'rails_helper'

RSpec.describe User, type: :model do
  let(:included_modules) { described_class.included_modules }
  let(:user) { described_class.new }
  let(:admin_role) { FactoryBot.create(:role, name: "admin") }
  let(:roles) { 2.times { |i| FactoryBot.create(:role, name: "role#{i}") }; Role.all }

  it 'has IuUserRoles functionality' do
    expect(included_modules).to include(::IuUserRoles)
    expect(included_modules).to include(LDAPGroupsLookup::Behavior)
    expect(user).to respond_to(:institution_patron?)
    expect(user).to respond_to(:image_editor?)
    expect(user).to respond_to(:ldap_lookup_key)
  end
  it 'has Hydra Role Management behaviors' do
    expect(included_modules).to include(Hydra::RoleManagement::UserRoles)
    expect(user).to respond_to(:admin?)
  end

  describe "#admin?" do
    context "when granted by regular roles" do
      before do
        allow(user).to receive(:roles).and_return([admin_role])
        allow(user).to receive(:ldap_roles).and_return([])
      end
      it "returns true" do
        expect(user.admin?).to be true
      end
    end
    context "when granted by ldap_roles" do
      before do
        allow(user).to receive(:roles).and_return([])
        allow(user).to receive(:ldap_roles).and_return(['admin'])
      end
      it "returns true" do
        expect(user.admin?).to be true
      end
    end
    context "when not granted by any roles" do
      before do
        allow(user).to receive(:roles).and_return([])
        allow(user).to receive(:ldap_roles).and_return([])
      end
      it "returns false" do
        expect(user.admin?).to be false
      end
    end
  end

  describe "#institution_patron?" do
    context "when logged in from CAS" do
      let(:user) do
        described_class.find_for_iu_cas(OpenStruct.new(provider: "cas",
                                                     uid: "testuser"))
      end

      it "is true" do
        expect(user).to be_institution_patron
      end
    end
    context "when not logged in from CAS" do
      before(:each) do
        allow(user).to receive(:provider).and_return(:not_cas)
      end
      it "is false" do
        expect(user).not_to be_institution_patron
      end
    end
  end

  describe "#authorized_patron?" do
    context "when not a institution_patron" do
      before(:each) do
        allow(user).to receive(:institution_patron?).and_return(false)
      end
      it "is false" do
        expect(user).not_to be_institution_patron
      end
    end
    context "when a campus patron" do
      before(:each) do
        allow(user).to receive(:institution_patron?).and_return(true)
      end
      context "without authorized groups configured" do
        before(:each) do
          allow(ESSI.config[:authorized_ldap_groups]).to receive(:blank?).and_return(true)
        end
        it "is true" do
          expect(user).to be_authorized_patron
        end
      end
      context "with authorized ldap groups configured" do
        context "when the user has group membership" do
          before(:each) { allow(user).to receive(:authorized_ldap_member?).and_return(true) }
          it "is true" do
            expect(user).to be_authorized_patron
          end
        end
        context "when the user lacks group membership" do
          before(:each) { allow(user).to receive(:authorized_ldap_member?).and_return(false) }
          it "is false" do
            expect(user).not_to be_authorized_patron
          end
        end
      end
    end
  end

  describe "#ldap_roles", :clean do
    before do
      groups1 = ['groupA', 'groupB']
      groups2 = ['groupB', 'groupC']
      allow(user).to receive(:member_of_ldap_group?).with(groups1).and_return(true)
      allow(user).to receive(:member_of_ldap_group?).with(groups2).and_return(false)
      allow(ESSI.config).to receive(:dig).with(:ldap, :group_roles).and_return({ roles[0].name => groups1, roles[1].name => groups2  })
    end
    it "returns ESSI-configured roles for the user's ldap_groups" do
      expect(user.ldap_roles).to include roles[0].name
      expect(user.ldap_roles).not_to include roles[1].name
    end
  end
end
