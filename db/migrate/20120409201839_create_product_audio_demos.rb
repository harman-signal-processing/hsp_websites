class CreateProductAudioDemos < ActiveRecord::Migration
  def change
    create_table :product_audio_demos do |t|
      t.integer :audio_demo_id
      t.integer :product_id

      t.timestamps
    end
  end
end
