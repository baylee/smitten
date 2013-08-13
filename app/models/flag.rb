class Flag < ActiveRecord::Base
  attr_accessible :flaggable_id, :flaggable_type, :flagger_id, :reason

  belongs_to :flagger, class_name: 'User', foreign_key: 'flagger_id'
  belongs_to :flaggable, polymorphic: true
end
