class CreateCaptchas < ActiveRecord::Migration
  def self.up
    options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :captchas, :options => options do |t|
      t.text :question
      t.string :answer1_text
      t.string :answer2_text
      t.string :answer3_text
      t.string :answer4_text
      t.string :answer1
      t.string :answer2
      t.string :answer3
      t.string :answer4
      t.string :question_key
      t.string :correct_answer

      t.timestamps
    end
    Captcha.create(
      :question => "How many bass players does it take to screw in a light bulb?",
      :answer1_text => "None. The keyboard player can do it with his left hand.",
      :answer2_text => "One.", 
      :answer3_text => "Four.", 
      :answer4_text => "Five.")
    Captcha.create(
      :question => "What is the difference between a musician and a large pizza?",
      :answer1_text => "A large pizza can feed a family.",
      :answer2_text => "Pepperoni.", 
      :answer3_text => "Pizza is cheesier.", 
      :answer4_text => "Musicians are crusty.")
    Captcha.create(
      :question => "How do you know when a drummer is at the front door?",
      :answer1_text => "The knocking keeps getting faster.",
      :answer2_text => "He isn't on his throne.", 
      :answer3_text => "You can't hear your amp over the crash.",
      :answer4_text => "No groupies are missing.")
  end

  def self.down
    drop_table :captchas
  end
end
