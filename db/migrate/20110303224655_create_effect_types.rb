class CreateEffectTypes < ActiveRecord::Migration
  def self.up
    create_table :effect_types do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
    add_column :effects, :effect_type_id, :integer
    ["Reverb", "Delay", "Wah", "Compression", "Noise Gate", "EQ", "Chorus", "Phaser", "Flanger", "Pitch", 
      "Vibrato/Rotary", "Tremolo", "Envelope"].each do |e|
        EffectType.create(:name => e)
    end
  end

  def self.down
    remove_column :effects, :effect_type_id
    drop_table :effect_types
  end
end