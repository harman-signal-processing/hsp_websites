class CreateProductCaseStudies < ActiveRecord::Migration[6.1]
  def change
    create_table :product_case_studies do |t|
      t.integer :product_id
      t.string :case_study_slug
      t.integer :position

      t.timestamps
    end
    add_index :product_case_studies, :product_id
    add_index :product_case_studies, :case_study_slug
  end
end
