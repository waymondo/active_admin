# Initializers
$ ->

  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    $(@).datepicker dateFormat: 'yy-mm-dd'

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
  $('#q_search').submit ->
    $(@).find(':input[value=""]').attr 'disabled', 'disabled'
