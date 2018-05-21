module Api
  module Subcollections
    module Results
      def find_results(id)
        MiqReportResult.for_user(User.current_user).find(id)
      end

      def results_query_resource(object)
        object.miq_report_results.for_user(User.current_user)
      end

      private

      def fetch_direct_virtual_attribute(type, resource, attr)
        return unless attr_accessible?(resource, attr)
        virtattr_accessor = virtual_attribute_accessor(type, attr)
        value = virtattr_accessor ? send(virtattr_accessor, resource) : virtual_attribute_search(resource, attr)
        if attr == "result_set"
          offset = request.params[:offset].to_i
          limit = request.params[:limit].to_i
          value = value.sort_by{|hash| hash[:id] }[offset...offset+limit] if limit > 0
        end
        result = { attr => normalize_virtual(nil, attr, value, :ignore_nil => true) }
        [value, result]
      end

      def set_additional_attributes
        @additional_attributes = %w(result_set result_set_count result_set_subcount)
      end
    end
  end
end
