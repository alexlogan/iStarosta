//$(function() {
//    var ready;
//    ready = function() {$("a.btn").click(function()
//    {
//        if ($(this).hasClass("btn-default"))
//        {
//            $(this).removeClass("btn-default").addClass("btn-info active");
//            $(this).children().first().attr("value", 1);
//        }
//        else if ($(this).hasClass("btn-info active"))
//        {
//            $(this).removeClass("btn-info active").addClass("btn-default");
//            $(this).children().first().attr("value", 0);
//        }
//    });
//    };
//    $(document).ready(ready);
//    $(document).on('page:load', ready);
//});

//$(function () {
//    $('.input-daterange').datepicker({
//        format: "yyyy-dd-mm",
//        autoclose: true,
//        todayHighlight: true
//    });
//});


    $(document).on('page:load', function() {
        $('.input-daterange').datepicker(
         {
            format: "yyyy-dd-mm",
            autoclose: true,
            todayHighlight: true
        });
    });
