class Application < ApplicationRecord
    validates_uniqueness_of :token
    attribute :chat_count, :integer, default: 0
end
