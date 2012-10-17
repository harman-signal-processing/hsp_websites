class CreateLabelSheets < ActiveRecord::Migration
  def change
    create_table :label_sheets do |t|
      t.string :name
      t.text :products

      t.timestamps
    end

    LabelSheet.create([
    	{name: "One-A", product_ids: "redline-overdrive, total-recall, blue-pearl-chorus, death-metal-distortion-e-pedal, dod-fx25b-envelope-filter, continuum-reverb"},
    	{name: "One-B", product_ids: "jet-flanger, compressor, octaver, double-cross-delay"},
    	{name: "Two", product_ids: "screamer-overdrive, amp-driver, glimmer-drive, rock-it-distortion, rodent-distortion, phaser-beam"},
    	{name: "Three", product_ids: "ce-chorus, flanger-affair, stone-phase, opto-tremolo, dm-delay, vintage-tape-delay"},
    	{name: "Four", product_ids: "240-plate-reverb, red-compressor, fuzzy, spring-tank-reverb, sound-off"},
    	{name: "Five", product_ids: "rotator, dod-overdrive-preamp250, lexicon-hall-reverb, dod-fx13-gonkulator-modulator, half-pipe-overdrive, strato-boost"},
    	{name: "Six", product_ids: "dod-fx69-grunge, unplugged, snake-charmer, freeze-wah, angelic-choir"},
    	{name: "Seven", product_ids: "vanishing-point, tone-boost, magic-fingers, swing-shift"}
    ])
  end
end
