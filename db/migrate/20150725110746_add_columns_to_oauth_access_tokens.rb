class AddColumnsToOauthAccessTokens < ActiveRecord::Migration
  def change
    add_column :oauth_access_tokens, :note, :string, after: :refresh_token
    add_column :oauth_access_tokens, :updated_at, :datetime, after: :created_at

    # for sqlite3
    change_column :oauth_access_tokens, :updated_at, :datetime, null: false
  end
end
