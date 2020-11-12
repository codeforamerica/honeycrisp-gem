require "active_model"

module Cfa
  module Styleguide
    class FormExample
      include ActiveModel::Model
      include ActiveModel::AttributeAssignment
      include ActiveModel::Validations::Callbacks

      attr_accessor :example_method_name,
                    :example_method_with_validation,
                    :example_method_name_month,
                    :example_method_name_day,
                    :example_method_name_year,
                    :example_method_with_validation_month,
                    :example_method_with_validation_day,
                    :example_method_with_validation_year,
                    :none

      def method_missing(method_name, *args, **kwargs, &block)
        if method_name.to_s.starts_with?("example_method_with_validation") && errors[method_name].empty?
          errors.add(method_name, "This is an example error message.")
        end
        return super unless method_name.to_s.starts_with?("example_method")

        nil
      end

      def respond_to_missing?(method_name, *_args)
        method_name.to_s.starts_with?("example_method")
      end
    end
  end
end
