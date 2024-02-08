# To make Ransack < 4 compatible with rail 7.1+
module Arel
  class Table
    alias :table_name :name
  end
end