class CreateProductFamilyCaseStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :product_family_case_studies do |t|
      t.integer :product_family_id
      t.string :case_study_id
      t.integer :position

      t.timestamps
    end
    add_index :product_family_case_studies, :product_family_id
  end
end
