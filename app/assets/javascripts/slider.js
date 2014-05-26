$(document).ready(function(){
    $('.hour-slider').slider({
        formater: function(value) {
            return value + ' h';
        }
    });
});