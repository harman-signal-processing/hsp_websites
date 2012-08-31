class AddDimensionsToTrainingModules < ActiveRecord::Migration
  def change
    add_column :training_modules, :width, :int
    add_column :training_modules, :height, :int
  end
end
