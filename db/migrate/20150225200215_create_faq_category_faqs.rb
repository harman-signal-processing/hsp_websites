class CreateFaqCategoryFaqs < ActiveRecord::Migration
  def change
    create_table :faq_category_faqs do |t|
      t.integer :faq_category_id
      t.integer :faq_id

      t.timestamps
    end
    add_index :faq_category_faqs, :faq_category_id
    add_index :faq_category_faqs, :faq_id
  end
end
