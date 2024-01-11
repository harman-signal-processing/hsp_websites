class ScheduledTask < ApplicationRecord
  belongs_to :schedulable, polymorphic: true

  has_many :scheduled_task_actions
  has_many :scheduled_task_logs

  validates :schedulable_type, presence: true
  validates :schedulable_id, presence: true

  accepts_nested_attributes_for :scheduled_task_actions

  def self.schedulable_options
    [
      ["Product Family", "ProductFamily"],
      ["Product", "Product"],
      ["News", "News"],
      ["Banner", "Banner"],
      ["Setting", "Setting"]
    ]
  end

  #writer
  def schedulable_friendly_id=(val)
    begin
      self.schedulable_id =  schedulable_type.constantize.send(:find, val).id
    rescue
      raise("could not find an ID based on the provided friendly_id")
    end
  end

  #reader
  def schedulable_friendly_id
    if schedulable_type.present? && schedulable_id.present?
      begin
        schedulable_type.constantize.send(:find, schedulable_id).friendly_id
      rescue
        "--"
      end
    else
      ""
    end
  end

  #which fields can be scheduled
  def schedulable_fields
    schedulable_type.constantize.send(:column_names).sort - ["id", "created_at", "updated_at", "cached_slug"]
  end

  def run!
    update(status: "running")
    scheduled_task_actions.each{|sta| sta.run!}
    update(status: scheduled_task_actions.pluck(:status).uniq.join(", "))
  end

end
