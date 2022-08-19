class ScheduledTaskAction < ApplicationRecord
  belongs_to :scheduled_task

  after_initialize :set_field_type

  def set_field_type
    if self.field_name.present? && self.scheduled_task.present?
      self.field_type ||= schedulable.column_for_attribute(field_name).type
    end
  end

  def schedulable
    self.scheduled_task.schedulable
  end

  def has_relation?
    field_name.match(/^(.*)_id$/) && schedulable.respond_to?($1)
  end

  def relation_name
    if field_name.match(/^(.*)_id$/)
      return $1
    end
  end

  def relation_class
    relation_name == "parent" ?
      scheduled_task.schedulable_type.classify.constantize :
      relation_name.classify.constantize
  end

  def options_for_select
    relation_class.all
  end

  def new_value
    if field_type == "integer"
      if has_relation?
        begin
          "#{new_integer_value} - " + relation_class.find(new_integer_value).name
        rescue
          new_integer_value
        end
      else
        new_integer_value
      end
    else
      new_value_by_field_type
    end
  end

  def new_value_by_field_type
    @new_value_by_field_type ||= self.send("new_#{field_type}_value".to_sym)
  end

  def run!
    log_entry = ""
    begin
      if schedulable.update("#{field_name}": new_value_by_field_type)
        log_entry = "Field \"#{field_name}\" successfully updated to: #{new_value_by_field_type}"
        update(status: "complete")
      else
        log_entry = "ERROR updating #{field_name}!"
        update(status: "failed")
      end
    rescue
      log_entry = "RESCUED ERROR updating #{field_name}"
    end
    ScheduledTaskLog.create(
      scheduled_task_id: scheduled_task.id,
      scheduled_task_action_id: self.id,
      description: log_entry
    )
  end
end
