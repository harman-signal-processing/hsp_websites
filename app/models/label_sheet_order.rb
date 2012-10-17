class LabelSheetOrder < ActiveRecord::Base
  attr_accessible :label_sheet_ids, :mailed_on, :user_id
  attr_accessor :label_sheet_ids
  serialize :label_sheets
  before_save :decode_label_sheets
end
