class CreateRepQuestions < ActiveRecord::Migration
  def self.up
    create_table :rep_questions do |t|
      t.integer :rep_report_id
      t.integer :position
      t.text :question

      t.timestamps
    end
  end

  def self.down
    drop_table :rep_questions
  end
end
