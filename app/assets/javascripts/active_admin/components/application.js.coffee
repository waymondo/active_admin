# Initializers
$ ->

  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    defaults = dateFormat: 'yy-mm-dd'
    options = $(@).data 'datepicker-options'
    $(@).datepicker $.extend(defaults, options)

  $("input.timepicker").each ->
    $i = $(@)
    $i.timepicker $i.data()

  $(".clear_filters_btn").click ->
    window.location.search = ""

  $(".dropdown_button").popover()

  $(".chzn").chosen()

  # $("input[type='text'].data-collection").each ->
  #   # console.log(v.split(","))
  #   $(@).autocomplete_collection()

  $('form').bind 'submit', ->
    $("li.autocomplete").each ->
      $li = $(@)
      $li.each ->
        if !$li.find('.search-choice').length
          $li.find('.chzn-done option[selected]').removeAttr('selected')
          $li.find('.chzn-done option').first().attr('selected', 'selected')
    true

  # Filter form: don't send any inputs that are empty
  $('.filter_form').submit ->
    $(@).find(':input').filter(-> @value is '').prop 'disabled', true

  # Filter form: for filters that let you choose the query method from
  # a dropdown, apply that choice to the filter input field.
  $('.filter_form_field.select_and_search select').change ->
    $(@).siblings('input').prop name: "q[#{@value}]"
