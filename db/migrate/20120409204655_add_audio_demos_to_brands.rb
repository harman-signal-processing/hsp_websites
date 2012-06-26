class AddAudioDemosToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_audio_demos, :boolean, :default => false
    Brand.find("lexicon").update_attributes(:has_audio_demos => true)
  end
end
