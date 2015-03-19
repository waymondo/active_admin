module ActiveAdmin
  module Inputs
    class AjaxAutocompleteInput < ::Formtastic::Inputs::StringInput

      def input_html_options
        options = super
        options[:class] = [options[:class], 'ajax-autocomplete'].compact.join(' ')
        options[:value] = ''
        options[:placeholder] = "Search for #{method.to_s}"
        options[:autocomplete] = 'off'
        options[:data] = options[:data] || {}
        options[:data][:method] = method.to_s
        options[:data][:collection] = options[:data][:collection] || collection_as_json
        options[:data][:json_url] = options[:data][:json_url] || json_url
        options[:data][:provide] = 'autocomplete-collection'
        # options[:name] = input_html_name
        options
      end

      # def input_html_name
      #   "#{object_name}[#{method.to_s.singularize}_ids]"
      # end

      # def to_html
      #   input_wrapping do
      #     label_html <<
      #     builder.text_field(input_name, input_html_options)
      #   end
      # end

      def search_scope
        options[:search] || :name_contains
      end

      def collection_as_json
        @object.send(method).map{|o| { id: o.id, name: o.name }}.to_json
      end

      def json_url
        "/admin/#{reflection_for(method).plural_name}?q%5B#{search_scope}%5D="
      end
    end
  end
end
