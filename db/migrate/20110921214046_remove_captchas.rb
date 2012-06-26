class RemoveCaptchas < ActiveRecord::Migration
  def self.up
    drop_table :captchas
  end

  def self.down
    create_table "captchas", :force => true do |t|
      t.text     "question"
      t.string   "answer1_text"
      t.string   "answer2_text"
      t.string   "answer3_text"
      t.string   "answer4_text"
      t.string   "answer1"
      t.string   "answer2"
      t.string   "answer3"
      t.string   "answer4"
      t.string   "question_key"
      t.string   "correct_answer"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "brand_id"
    end
    
  end
end
