class Chat < ApplicationRecord
  belongs_to :application
  validates_uniqueness_of :number, scope: :application_id
  attribute :messages_count, :integer, default: 0
end
