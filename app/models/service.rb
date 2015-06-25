class Service < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :oauth_token, :expires_at
end
