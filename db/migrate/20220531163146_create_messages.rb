class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :number
      t.references :chat, null: false, foreign_key: true
      t.string :content
      t.timestamps
    end
  end
end
