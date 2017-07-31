initSort = ->
  $(".index_table").has("td.col-position").each ->
    $table = $(@)
    return if $table.data('aa.reorder')
    $table.data('aa.reorder', true)
    resource = $table.attr('id').split("index_table_")[1]
    $table.find("tbody").sortable
      update: (e, ui) ->
        $tr = $(@).find("tr")
        tr_ids = $tr.map( -> @.id.split("_").pop() ).toArray().join(",")
        route = "#{resource}/sort"
        $.post "#{resource}/sort", sort: tr_ids, ->
          # update position numbering and fix striping
          $table.find("tr").each (i) ->
            if i % 2 is 0
              $(@).removeClass("odd").addClass("even")
            else
              $(@).removeClass("even").addClass("odd")
            $(@).find("td.col-position").text(i)
      helper: (e, ui) ->
        ui.children().each ->
          $(@).width($(@).width())
        ui

document.addEventListener('turbolinks:load', initSort)
$ -> initSort()
