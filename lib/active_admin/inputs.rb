module ActiveAdmin
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DatepickerInput
    autoload :TimepickerInput
    autoload :DatetimepickerInput
    autoload :AutocompleteInput
    autoload :AjaxAutocompleteInput

    autoload :FilterBase
    autoload :FilterStringInput
    autoload :FilterDateRangeInput
    autoload :FilterNumericInput
    autoload :FilterSelectInput
    autoload :FilterCheckBoxesInput
  end
end
