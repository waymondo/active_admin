module ActiveAdmin
  module Inputs
    class RedactorInput < ::Formtastic::Inputs::TextInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "redactor"].compact.join(' ')
        options
      end
      def wrapper_classes
        classes = super
        classes.gsub(/redactor/, '')
      end
    end
  end
end
