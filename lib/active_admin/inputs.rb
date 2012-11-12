module ActiveAdmin
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DatepickerInput
    autoload :TimepickerInput
    autoload :DatetimepickerInput
    autoload :AutocompleteInput
    autoload :AjaxAutocompleteInput
    autoload :RedactoredInput

    autoload :FilterBase
    autoload :FilterStringInput
    autoload :FilterDateRangeInput
    autoload :FilterNumericInput
    autoload :FilterSelectInput
    autoload :FilterCheckBoxesInput
    autoload :FilterBooleanInput
  end
end
