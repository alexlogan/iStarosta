$ ->

  $(document).on 'click', 'a.btn',  ->
    if $(this).hasClass("btn-default")
      $(this).removeClass("btn-default").addClass "btn-primary active"
      $(this).children().first().attr "value", 1
    else if $(this).hasClass("btn-primary active")
      $(this).removeClass("btn-primary active").addClass "btn-default"
      $(this).children().first().attr "value", 0
    return

$(document).on "ready page:load", ->
  $(".input-daterange").datepicker
    format: "yyyy-mm-dd"
    autoclose: true
    todayHighlight: true
  return

$(document).on "ready page:load", ->
  $(".input-group.date.logs").datepicker
    format: "yyyy-mm-dd"
    endDate: "today"
    daysOfWeekDisabled: "6"
    autoclose: true
    todayHighlight: true
  return

$(document).on "ready page:load", ->
  $(".input-group.date.settings").datepicker
    format: "yyyy-mm-dd"
    autoclose: true
    todayHighlight: true
  return