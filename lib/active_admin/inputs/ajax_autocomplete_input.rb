module ActiveAdmin
  module Inputs
    class AjaxAutocompleteInput < ::Formtastic::Inputs::StringInput

      def input_html_options
        options = super
        options[:class] = [options[:class], "ajax-autocomplete"].compact.join(' ')
        options[:search] = options[:search] || :name_contains
        options[:value] = ""
        options[:placeholder] = "Search for #{method.to_s}"
        options[:data] = options[:data] || Hash.new
        options[:data][:method] = method.to_s
        options[:data][:collection] = options[:data][:collection] || collection_as_json
        options[:data][:json_url] = options[:data][:json_url] || json_url
        options[:data][:provide] = "autocomplete-collection"
        options
      end

      def collection_as_json
        @object.send(method).map{|o| { id: o.id, name: o.name }}.to_json
      end

      def input_name
        "#{object_name}[#{method.to_s.singularize}_ids]"
      end

      def json_url
        "/admin/#{reflection_for(method).plural_name}?q%5B#{options[:search].to_s}%5D="
      end

    end
  end
end
