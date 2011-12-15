module ActiveAdmin
  module Inputs
    class DatetimepickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "datetimepicker"].compact.join(' ')
        options
      end
    end
  end
end
