class AddCommentToCustomizableAttributeValues < ActiveRecord::Migration[6.1]
  def change
    add_column :customizable_attribute_values, :comment, :string
    add_column :customizable_attribute_values, :code, :string
  end
end
