class Spark < ActiveRecord::Base
  attr_accessible :title, :content, :input_location, :latitude, :longitude, :user_id, :location_only

  validates_presence_of :latitude, :longitude
  validates_length_of :content, :maximum => 1000, :allow_blank => true

  belongs_to :user
  has_many :flags, as: :flaggable

  reverse_geocoded_by :latitude, :longitude

  def is_flagged_by_user?(user)
    x = false
    self.flags.each do |flag|
      if flag.flagger_id == user.id
        x = true
      end
    end
    x
  end

  def created_near(time)
    self.created_at.between?(time - 3.hours, time + 3.hours)
  end
end
