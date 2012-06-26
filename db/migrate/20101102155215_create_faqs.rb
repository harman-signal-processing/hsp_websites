class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.integer :product_id
      t.text :question
      t.text :answer
      t.boolean :hidden

      t.timestamps
    end
  end

  def self.down
    drop_table :faqs
  end
end
