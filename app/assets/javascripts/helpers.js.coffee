jQuery.fn.reverse = ->
  this.pushStack(this.get().reverse(), arguments)

window.concentrate = ->
  $('form :input:visible:first').focus()

window.listenForShortcuts = ->
  $(document).bind 'keypress', 'a', ->
    $('#add_entry').click()

  $(document).bind 'keypress', 's', ->
    $('#search').click()

window.onresize = (event) ->
  l  = $('#ledger')
  dh = $(window).height()
  hh = 182 # Header height
  lh = l.height()
  l.height(dh - hh)

  window.ledger.centerFirstClearedEntry() if window.ledger.el

