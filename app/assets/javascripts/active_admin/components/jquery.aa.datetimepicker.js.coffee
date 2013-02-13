DateTimePicker = (element, options) ->
  @options = $.extend({}, $.fn.date_time_picker.defaults, options)
  @$datepicker = $(element).removeClass("datetimepicker")
  @$timepicker = @$datepicker.clone().insertAfter(@$datepicker)
  @$hidden = @$datepicker.clone().attr('type','hidden').insertAfter(@$timepicker)
  @$datepicker.add(@$timepicker).removeAttr("name")
  @initialize()
  @listen()

DateTimePicker.prototype =

  constructor: DateTimePicker
  initialize: ->

    if @$hidden.val().trim().length
      date_and_time = @$hidden.val().split(" ")
      @$datepicker.val date_and_time[0]
      @$timepicker.val date_and_time[1]

    @$timepicker.timepicker
      minTime: @$timepicker.attr('data-minTime')
      maxTime: @$timepicker.attr('data-maxTime')
      selectOnBlur: @$timepicker.attr('data-selectOnBlur')?

    @$datepicker.datepicker
      dateFormat: 'yy-mm-dd'
      ampm: true
      autoclose: true

  listen: ->
    @$datepicker
      .on('change',     $.proxy(@change, @))

    @$timepicker
      .on('change',     $.proxy(@change, @))

  change: ->
    d = @$datepicker.datepicker('getDate') or new Date()
    t = @$timepicker.timepicker('getSecondsFromMidnight') or 0
    dateTimeMoment = moment(d).hours(0).minutes(0).seconds(t)
    @$hidden.val(dateTimeMoment.format("YYYY-MM-DDTHH:mm:ss"))

$.fn.date_time_picker = (options = {}) ->
  @each ->
    $(@).data('date-time-picker', (data = new DateTimePicker(@, options)))

$.fn.date_time_picker.defaults = {}
$.fn.date_time_picker.Constructor = DateTimePicker

$ ->
  $('input.datetimepicker').date_time_picker()

  $(".has_many a.button").click ->
    $('input.datetimepicker').date_time_picker()
