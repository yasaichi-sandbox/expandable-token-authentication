class PersonalAccessToken < Doorkeeper::AccessToken
  self.table_name = 'oauth_access_tokens'

  belongs_to :resource_owner, class_name: :User

  validates :application_id, absence: true
  validates :note, presence: true, length: { maximum: 255 }
  validates :resource_owner, presence: true

  validate do
    unless Doorkeeper.configuration.scopes.has_scopes?(scopes)
      errors.add(:scopes, I18n.t('errors.messages.invalid'))
    end
  end

  before_validation do
    self.scopes = Doorkeeper.configuration.default_scopes if scopes.empty?
  end

  default_scope -> { where(application_id: nil) }
end
