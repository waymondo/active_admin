module ActiveAdmin
  module Inputs
    class AutocompleteInput < ::Formtastic::Inputs::SelectInput
      def input_html_options
        options = super
        options[:class] = [options[:class], "chzn"].compact.join(' ')
        options[:include_blank] = true
        options
      end
      def collection
        super.unshift(["",""])
      end
    end
  end
end
