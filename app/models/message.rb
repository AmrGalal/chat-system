class Message < ApplicationRecord
  belongs_to :chat
  validates_uniqueness_of :number
end
