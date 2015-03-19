@AutocompleteCollection = (element, options) ->
  @options = $.extend({}, $.fn.autocomplete_collection.defaults, options)
  @resource = @options.resource or @options.method
  @$element = $(element)
  @$element.wrap $(document.createElement('div')).addClass('autocomplete-collection-wrap')
  @$hidden = @$element.clone().attr('type','hidden').insertAfter(@$element)
  @$hidden.attr 'name', @$element.attr('name')
  @$element.removeAttr 'name'
  @matcher = @options.matcher or @matcher
  @sorter = @options.sorter or @sorter
  @highlighter = @options.highlighter or @highlighter
  @$menu = $(@options.menu).appendTo('body')
  @$collection = $(@options.collectionUi).insertAfter(@$element)
  @collection = @options.collection or JSON.parse(@$element.attr('data-collection')) or []
  @source = @options.source or @source
  @onselect = @options.onselect
  @onenter = @options.onenter
  @allowNew = @options.allowNew
  @strings = true
  @shown = false
  @build()
  @listen()

AutocompleteCollection.prototype =
  constructor: AutocompleteCollection

  collectionIds: ->
    $.map @collection, (o) -> o.id

  indexInCollection: (id) ->
    $.inArray id, @collectionIds()

  source: (autocomplete_collection, query) ->
    url = @$element.attr('data-json-url')
    xhr = $.getJSON(url+query)
    xhr.complete (data) =>
      resp = JSON.parse(data.responseText)
      resp = resp[@resource] or resp[@resource+"s"] or resp
      autocomplete_collection.process(resp)

  select: (go) ->
    $active = @$menu.find('.active')
    if @allowNew and ($active.find("a").hasClass("add-new") or !@shown)
      @addNew()
    else
      val = JSON.parse($active.attr('data-value'))
      text = @getVal(val)
      @$element.val(text)
      @onselect(val, go) if typeof @onselect == "function"
      @add(val)
    @hide()

  addNew: ->
    text = @$element.val()
    val = @setVal(text)
    @add(val)
    @$element.val("")

  getVal: (val) ->
    if !@strings
      val[@options.property]
    else
      val

  setVal: (text) ->
    if !@strings
      val = {}
      val[@options.property] = text
      val
    else
      text

  show: ->
    pos = $.extend {}, @$element.offset(),
      height: @$element[0].offsetHeight
    @$menu.css
      top: pos.top + pos.height
      left: pos.left
    @$menu.show()
    @shown = true
    @

  hide: ->
    @$menu.hide()
    @shown = false
    @

  draw: (val) ->
    $li = $(document.createElement("li"))
      .addClass("autocomplete-collection-collection-item")
      .attr('data-autocomplete-collection-value', val[@options.property])
      .attr('data-autocomplete-collection-id', val.id)
      .html("<span class='ac-prop-val'>#{val[@options.property]}</span>")
    $x = $(document.createElement("a"))
      .addClass("autocomplete-collection-remove-item")
      .html("&times;")
      .appendTo($li)
      .bind 'click', => @remove(val)
    @$collection.append $li
    @$element.val ""

  setValue: ->
    @$element.data('collection', @collection)
    @$hidden.val JSON.stringify @collection

  collectionAdd: (val) ->
    @collection.push(val)
    @setValue()

  collectionRemove: (i) ->
    @collection.splice i, 1
    @setValue()

  add: (val) ->
    if i = @indexInCollection(val.id) == -1
      @draw(val)
      @collectionAdd(val)

  remove: (val) ->
    if (i = @indexInCollection(val.id)) > -1
      @collectionRemove(i)
      @$collection.find("[data-autocomplete-collection-id='#{val.id}']").remove()
    else if @allowNew
      text = @getVal(val)
      if ($item = @$collection.find("[data-autocomplete-collection-value='#{text}']")).length
        @collectionRemove(i)
        $item.remove()

  build: ->
    $.each @collection, (i, val) =>
      @draw(val)
    @setValue()
    return if !$.fn.sortable
    @$collection.sortable
      stop: $.proxy(@collectionReorder, @)

  collectionReorder: (e, ui) ->
    orderedCollection = []
    for li, i in @$collection.children()
      do (li) =>
        name = $(li).find(".ac-prop-val").text()
        items = $.grep @collection, (itm) -> itm.name is name
        return if !items.length
        item = items[0]
        item.position = i + 1
        orderedCollection.push item
    orderedCollection.sort (a, b) ->
      if a.position < b.position
        -1
      else
        if a.position > b.position then 1 else 0
    @collection = orderedCollection
    @setValue()

  lookup: (event) ->
    that = @
    @query = @$element.val()
    if typeof @source == "function"
      value = @source(@, @query)
      if value
        @process(value)
      else
        @process(@source)

  process: (results) ->
    @strings = false if results.length and typeof results[0] isnt "string"
    @query = @$element.val()
    return @hide() if !@query and typeof @source is "function"
    items = @sorter $.grep results, (item) =>
      item = item[@options.property] unless @strings
      item if @matcher(item)
    return @hide() if !items.length and !@options.otherOption
    @render(items.slice(0, @options.items)).show()

  matcher: (item) ->
    ~item.toLowerCase().indexOf(@query.toLowerCase())

  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []
    item = undefined
    sortby = undefined
    while item = items.shift()
      if @strings
        sortby = item
      else
        sortby = item[@options.property]
      unless sortby.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push item
      else if ~sortby.indexOf(@query)
        caseSensitive.push item
      else
        caseInsensitive.push item
    beginswith.concat caseSensitive, caseInsensitive

  highlighter: (item) ->
    item.replace new RegExp('(' + @query + ')', 'ig'), ($1, match) ->
      return '<strong>' + match + '</strong>'

  render: (items) ->
    that = @
    items = $(items).map (i, item) ->
      i = $(that.options.item).attr('data-value', JSON.stringify(item))
      if !that.strings
        item = item[that.options.property]
        i.find('a').html(that.highlighter(item))
        return i[0]
    @$menu.html(items)
    if @allowNew
      $addNewLi = $(@options.item).prop('data-value', @query)
      $addNewLi.find("a").addClass('add-new icon-plus').html("Add new item")
      @$menu.append $addNewLi
    @$menu.children().first().addClass('active')
    @

  next: (event) ->
    active = @$menu.find('.active').removeClass('active')
    next = active.next()
    if !next.length
      next = $(@$menu.find('li')[0])
    next.addClass('active')
    @

  prev: (event) ->
    active = @$menu.find('.active').removeClass('active')
    prev = active.prev()
    if !prev.length
      prev = @$menu.find('li').last()
    prev.addClass('active')
    @

  eventSupported: (eventName) ->
    isSupported = eventName of @$element
    unless isSupported
      @$element.setAttribute eventName, "return;"
      isSupported = typeof @$element[eventName] is "function"
    isSupported

  listen: ->
    @$element
      .on("focus",    $.proxy(@focus, @))
      .on('blur',     $.proxy(@blur, @))
      .on('keypress', $.proxy(@keypress, @))
      .on('keyup',    $.proxy(@keyup, @))

    @$element.on "keydown", $.proxy(@keypress, @) if @eventSupported("keydown")

    @$menu
      .on('click', $.proxy(@click, @))
      .on('mouseenter', 'li', $.proxy(@mouseenter, @))
      .on("mouseleave", "li", $.proxy(@mouseleave, @))

  move: (e) ->
    if !@shown
      if e.keyCode == 13
        return false
      else
        return
    switch e.keyCode
      when 9, 13, 27
        e.preventDefault()
        break
      when 38
        e.preventDefault()
        @prev()
        break
      when 40
        e.preventDefault()
        @next()
        break
    e.stopPropagation()

  keydown: (e) ->
    @suppressKeyPressRepeat = ~$.inArray(e.keyCode, [40,38,9,13,27])
    @move(e)

  keypress: (e) ->
    return if @suppressKeyPressRepeat
    @move(e)

  keyup: (e) ->
    switch e.keyCode
      when 40, 38, 16, 17, 18, 91, 16 # down / up arrow
        break
      when 9 # tab
        return if !@shown or !@query
        @select()
        break
      when 13 # enter
        if !@shown
          @onenter(e) if typeof @onenter == "function"
          @select() if @allowNew
        else
          @select()
        break
      when 27 # escape
        return if !@shown
        @hide()
        break
      else
        @lookup()
    e.stopPropagation()
    e.preventDefault()

  focus: (e) ->
    @focused = true
    setTimeout =>
      @lookup()
    , 100 if typeof @source isnt "function"

  blur: (e) ->
    @focused = false
    @hide() if not @mousedover and @shown

  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @select(true)

  mouseenter: (e) ->
    @mousedover = true
    @$menu.find('.active').removeClass('active')
    $(e.currentTarget).addClass('active')

  mouseleave: (e) ->
    @mousedover = false
    @hide() if not @focused and @shown

$.fn.autocomplete_collection = (option) ->
  @each ->
    $this = $(@)
    data = $this.data('autocomplete-collection')
    options = typeof option == 'object' and option
    if !data
      $this.data('autocomplete-collection', (data = new AutocompleteCollection(@, options)))
    if typeof option == 'string'
      data[option]()

$.fn.autocomplete_collection.defaults =
  collectionUi: '<ul class="autocomplete-collection"></ul>'
  items: 8
  menu: '<ul class="autocomplete_collection dropdown-menu"></ul>'
  item: '<li><a href="#"></a></li>'
  onselect: null
  onenter: null
  allowNew: false
  property: 'name'

$.fn.autocomplete_collection.Constructor = AutocompleteCollection

$ ->
  $('[data-provide="autocomplete-collection"]').each ->
    $this = $(@)
    return if $this.data('autocomplete-collection')
    $this.autocomplete_collection($this.data())
