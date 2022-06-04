class AddIndexToModels < ActiveRecord::Migration[7.0]
  def change
    add_index :applications, :token, unique: true
    add_index :chats, [:application_id, :number], unique: true
    add_index :messages, [:chat_id, :number], unique: true
  end
end
