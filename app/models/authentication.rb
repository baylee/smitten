class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider
end
