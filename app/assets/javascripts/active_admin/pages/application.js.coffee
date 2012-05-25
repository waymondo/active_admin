#
# Active Admin JS
#

$ = jQuery
$ ->

  $(".datepicker").datepicker dateFormat: "yy-mm-dd"
  $(".timepicker").timepicker ampm: true
  $(".datetimepicker").datetimepicker
    dateFormat: 'yy-mm-dd'
    ampm: true

  $(".clear_filters_btn").click ->
    window.location.search = ""
    false

  $(".dropdown_button").popover()

  $(".chzn").chosen()

  $('form').bind 'submit', ->
    $("li.autocomplete").each ->
      $li = $(@)
      $li.each ->
        if !$li.find('.search-choice').length
          $li.find('.chzn-done option[selected]').removeAttr('selected')
          $li.find('.chzn-done option').first().attr('selected', 'selected')
    true
