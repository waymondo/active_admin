module ActiveAdmin
  module Inputs
    class TimepickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "timepicker"].compact.join(' ')
        options[:value] = formatted_time
        options
      end
      def formatted_time
        @object.send(method).blank? ? "" : @object.send(method).strftime("%I:%M%P")
      end
    end
  end
end
