// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require fancybox
//= require_tree .

$(document).ready(function() {
    var $modal = $('#modal');
    var $modal_close = $modal.find('.close');
    var $modal_container = $('#modal-container');
    $("ul#userDrop").hide();
    $('ul#ExploreDrop').hide();
    $("div#userMenu").mouseenter(function(e) {
        e.preventDefault();
        $("ul#userDrop").show();
    });
    $("div#userMenu").mouseleave(function(e) {
        e.preventDefault();
        $("ul#userDrop").hide();
    });

    $("div#dashboard").mouseenter(function(e) {
        e.preventDefault();
        $("ul#ExploreDrop").show();
    });
    $("div#dashboard").mouseleave(function(e) {
        e.preventDefault();
        $("ul#ExploreDrop").hide();
    });

    $("div#createNewMenu a").fancybox({
            padding: 0,
            margin: 0
    });

    $("div#Sign a#SignInTop").fancybox({
        padding: 0,
        margin: 0,
        minWidth: 600
    });


    $("div#Sign a#SignUpTop").fancybox({
        padding: 0,
        margin: 0,
        minWidth: 600
    });
// Modal JavaScript Begin

    // $('div#createNewMenu').click(function(e) {
    //     $modal
    //       .prepend($modal_close)
    //       .css('top', $(window).scrollTop() + 40)
    //       .show();
    //     $modal_container.show();
    // });

    // $('.close', '#modal').live('click', function(){
    //     $modal_container.hide();
    //     $modal.hide();
    //     return false;
    //   });

// Modal JavaScript End
});
