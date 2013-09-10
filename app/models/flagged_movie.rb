class FlaggedMovie < ActiveRecord::Base
  belongs_to :user
  scope :wanted, -> { where(state: 'wanted') }
end
