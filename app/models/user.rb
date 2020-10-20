class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats
  include Hydra::RoleManagement::UserRoles
  include ::IuUserRoles

  # Enable ADS group lookup
  include LDAPGroupsLookup::Behavior
  alias_attribute :ldap_lookup_key, :uid

  # Provide dummy :password attribute to satisfy Hyrax FactoryBot factories
  attr_accessor :password

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:cas]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  # Modified method from hydra-role-management Hydra::RoleManagement::UserRoles
  # Grants registered status for authenticated visibility ("Institution") by ldap group membership, if so configured, and admins
  def groups
    g = roles.map(&:name)
    g += ldap_roles
    g += ['registered'] if authorized_patron? || g.include?('admin')
    g
  end

  # Roles to add depending on user's LDAP groups and ESSI configuration
  def ldap_roles
    mappings = ESSI.config.dig(:ldap, :group_roles) || {}
    mappings.select { |role, groups| member_of_ldap_group?(groups) }.keys
  end

  # Modified method from hydra-role-management Hydra::RoleManagement::UserRoles
  def admin?
    groups.include? 'admin'
  end

  def authorized_ldap_member?(force_update = nil)
    if force_update == :force ||
        authorized_membership_updated_at.nil? ||
        authorized_membership_updated_at < Time.now - 1.day
      groups = ESSI.config[:authorized_ldap_groups] || []
      self.authorized_membership = member_of_ldap_group?(groups)
      self.authorized_membership_updated_at = Time.now
      save
    end
    authorized_membership
  end

  def self.find_for_iu_cas(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = user.try(:ldap_mail)
      user.email = [auth.uid, '@', ESSI.config.dig(:ldap, :default_email_domain)].join if user.email.blank?
    end
  end
end
