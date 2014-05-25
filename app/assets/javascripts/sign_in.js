$(function() {
    startTime();
    $(".center").center();
    $(window).resize(function() {
        $(".center").center();
    });
});

/*  */
function startTime()
{
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();

    // add a zero in front of numbers<10
    m = checkTime(m);
    s = checkTime(s);

    //Check for PM and AM
    var day_or_night = (h > 11) ? "PM" : "AM";

    //Convert to 12 hours system
    if (h > 12)
        h -= 12;

    //Add time to the headline and update every 500 milliseconds
    $('#time').html(h + ":" + m + ":" + s + " " + day_or_night);
    setTimeout(function() {
        startTime()
    }, 500);
}

function checkTime(i)
{
    if (i < 10)
    {
        i = "0" + i;
    }
    return i;
}

/* CENTER ELEMENTS IN THE SCREEN */
jQuery.fn.center = function() {
    this.css("position", "absolute");
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
        $(window).scrollTop()) - 30 + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
        $(window).scrollLeft()) + "px");
    return this;
}