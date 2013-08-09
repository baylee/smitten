class Spark < ActiveRecord::Base
  attr_accessible :content, :latitude, :longitude, :user_id

  belongs_to :user
end
