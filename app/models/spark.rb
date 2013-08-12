class Spark < ActiveRecord::Base
  attr_accessible :content, :latitude, :longitude, :user_id, :location_only

  validates_presence_of :latitude, :longitude

  belongs_to :user
  reverse_geocoded_by :latitude, :longitude
end
