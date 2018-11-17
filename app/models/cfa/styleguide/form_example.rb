require "active_model"

module Cfa
  module Styleguide
    class FormExample
      include ActiveModel::Model
      include ActiveModel::AttributeAssignment
      include ActiveModel::Validations::Callbacks

      attr_accessor :example_input,
                    :example_checkbox_choice1,
                    :example_checkbox_choice2,
                    :example_radio_set,
                    :example_radio_set_with_follow_up,
                    :example_range_upper,
                    :example_range_lower,
                    :example_date_select_month,
                    :example_date_select_day,
                    :example_date_select_year,
                    :example_textarea
    end
  end
end