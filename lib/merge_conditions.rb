# :nocov:
module Geokit
  module ActsAsMappable
    module ClassMethods
      def merge_conditions(*conditions)
        segments = []

        conditions.each do |condition|
          unless condition.blank?
            sql = sanitize_sql(condition)
            segments << sql unless sql.blank?
          end
        end

        "(#{segments.join(') AND (')})" unless segments.empty?
      end
    end
  end
end
# :nocov:
