class AddCommentToCustomizableAttributes < ActiveRecord::Migration[6.1]
  def change
    add_column :customizable_attributes, :comment, :string
  end
end
