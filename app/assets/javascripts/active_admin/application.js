/* Active Admin JS */
$(function(){
  
  // time and date pickers
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'})
  $(".timepicker").timepicker({ampm: true})
  $(".datetimepicker").datetimepicker({
    dateFormat: 'yy-mm-dd',
    ampm: true
  })
  
  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  })
  
  // autocomplete
  $(".chzn").chosen()
  // hack to remove selection if none is selected
  $('form').bind('submit', function(){
    $("li.autocomplete").each(function(){
      var $li = $(this)
      $li.each(function(){
        if (!$li.find('.search-choice').length) {
          $li.find('.chzn-done option[selected]').removeAttr('selected')
          $li.find('.chzn-done option').first().attr('selected', 'selected')
        }
      })
    })
    return true
  })
  
})
