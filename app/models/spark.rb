class Spark < ActiveRecord::Base
  attr_accessible :title, :content, :input_location, :latitude, :longitude, :user_id, :location_only

  validates_presence_of :latitude, :longitude
  validates_length_of :content, :maximum => 1000, :allow_blank => true

  belongs_to :user
  has_many :flags, as: :flaggable

  reverse_geocoded_by :latitude, :longitude
end
