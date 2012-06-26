class CreateProductEffects < ActiveRecord::Migration
  def self.up
    create_table :product_effects do |t|
      t.integer :product_id
      t.integer :effect_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_effects
  end
end
