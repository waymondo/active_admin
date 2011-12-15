module ActiveAdmin
  module Inputs
    class TimepickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "timepicker"].compact.join(' ')
        options
      end
    end
  end
end
