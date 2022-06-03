require 'elasticsearch/model'
class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  def self.partial_match(query, chat_id)
    finalQuery = "*#{query}*"
    response = Message.__elasticsearch__.search({
      "query": {
        "bool": {
          "must": {
            "wildcard": { "content": finalQuery }
          },
          "filter": {
            "term": { "chat_id": chat_id }
          }
        }
      }
    })
    return response.records.to_a
  end
end
