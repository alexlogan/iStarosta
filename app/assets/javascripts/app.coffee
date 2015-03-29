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
    language: "ru"
  return

$(document).on "ready page:load", ->
  $(".input-group.date.logs").datepicker
    format: "yyyy-mm-dd"
    endDate: "today"
    daysOfWeekDisabled: "7"
    autoclose: true
    todayHighlight: true
    language: "ru"
  return

$(document).on "ready page:load", ->
  $(".input-group.date.settings").datepicker
    format: "yyyy-mm-dd"
    autoclose: true
    todayHighlight: true
    language: "ru"
  return

$(document).on "ready page:load", ->
  $(".input-group.form-control.group.name").select2
    placeholder: "Выберете группу"
    allowClear: true
  return