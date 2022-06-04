class Chat < ApplicationRecord
  belongs_to :application
  attribute :messages_count, :integer, default: 0
  has_many :messages, dependent: :delete_all
  validates :number, uniqueness: { scope: :application_id,
    message: "Can't have duplicate chat numbers per app" }
end
