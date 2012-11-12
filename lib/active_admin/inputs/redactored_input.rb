module ActiveAdmin
  module Inputs
    class RedactoredInput < ::Formtastic::Inputs::TextInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "redactor"].compact.join(' ')
        options
      end      
    end
  end
end
