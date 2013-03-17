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

/******************************************

Image Tick v1.0 for jQuery
==========================================
Provides an unobtrusive approach to image
based checkboxes and radio buttons
------------------------------------------
by Jordan Boesch
www.boedesign.com
June 8, 2008


Modified June 25, 2010:
- Radio buttons can have individual images
by Simen Echholt
http://stackoverflow.com/questions/3114166/#3114911
******************************************/

(function($){

    $.fn.imageTick = function(options) {

        var defaults = {
            tick_image_path: "images/radio.gif",
            no_tick_image_path: "no_images/radio.gif",
            image_tick_class: "ticks_" + Math.floor(Math.random()),
            hide_radios_checkboxes: false
        };

        var opt = $.extend(defaults, options);

        return this.each(function(){

            var obj = $(this);
            var type = obj.attr('type'); // radio or checkbox

            var tick_image_path = typeof opt.tick_image_path == "object" ?
                opt.tick_image_path[this.value] || opt.tick_image_path["default"] :
                opt.tick_image_path;

            var no_tick_image_path = function(element_id) {
                var element = document.getElementById(element_id) || { value: "default" };
                return typeof opt.no_tick_image_path == "object" ?
                    opt.no_tick_image_path[element.value] || opt.no_tick_image_path["default"]:
                    opt.no_tick_image_path;
            }

            // hide them and store an image background
            var id = obj.attr('id');
            var imgHTML = '<img src="' + no_tick_image_path(id) + '" alt="no_tick" class="' + opt.image_tick_class + '" id="tick_img_' + id + '" />';

            obj.before(imgHTML);
            if(!opt.hide_radios_checkboxes){
                obj.css('display','none');
            }

            // if something has a checked state when the page was loaded
            if(obj.attr('checked')){
                $("#tick_img_" + id).attr('src', tick_image_path);
            }

            // if we're deadling with radio buttons
            if(type == 'radio'){

                // if we click on the image
                $("#tick_img_"+id).click(function(){
                    $("." + opt.image_tick_class).each(function() {
                        var r = this.id.split("_");
                        var radio_id = r.splice(2,r.length-2).join("_");
                        $(this).attr('src', no_tick_image_path(radio_id))
                    });
                    $("#" + id).trigger("click");
                    $(this).attr('src', tick_image_path);
                });

                // if we click on the label
                $("label[for='" + id + "']").click(function(){
                    $("." + opt.image_tick_class).each(function() {
                        var r = this.id.split("_");
                        var radio_id = r.splice(2,r.length-2).join("_");
                        $(this).attr('src', no_tick_image_path(radio_id))
                    });
                    $("#" + id).trigger("click");
                    $("#tick_img_" + id).attr('src', tick_image_path);
                });

            }

            // if we're deadling with checkboxes
            else if(type == 'checkbox'){

                $("#tick_img_" + id).click(function(){
                    $("#" + id).trigger("click");
                    if($(this).attr('src') == no_tick_image_path(id)){
                        $(this).attr('src', tick_image_path);
                    }
                    else {
                        $(this).attr('src', no_tick_image_path(id));
                    }

                });

                // if we click on the label
                $("label[for='" + id + "']").click(function(){
                    if($("#tick_img_" + id).attr('src') == no_tick_image_path(id)){
                        $("#tick_img_" + id).attr('src', tick_image_path);
                    }
                    else {
                        $("#tick_img_" + id).attr('src', no_tick_image_path(id));
                    }
                });

            }

        });
    }

})(jQuery);

$(document).ready(function() {
    var $modal = $('#modal');
    var $modal_close = $modal.find('.close');
    var $modal_container = $('#modal-container');
    $("ul#userDrop").hide();
    $('ul#ExploreDrop').hide();
    $("#BallList").show();
    $("#FitList").hide();
    $("#WaterList").hide();
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

    $("input[name='event[category]']").imageTick({
        tick_image_path: {
            BallSports: "/assets/ballsport-checked.png",
            Fitness: "/assets/fitness-checked.png",
            WaterSports: "/assets/water-checked.png"
            //"default": "images/gender/default_checked.jpg" //optional default can be used
        },
        no_tick_image_path: {
            BallSports: "/assets/ballsport-uncheck.png",
            Fitness: "/assets/fitness-uncheck.png",
            WaterSports: "/assets/water-uncheck.png"
            //"default": "images/gender/default_unchecked.jpg" //optional default can be used
        },
        image_tick_class: "Type",
    });


    $("input:radio[name='event[category]']").change( function() {
        if ($(this).is(':checked') && $(this).val() == 'BallSports') {
            $("div#BallList").show();
            $("div#FitList").hide();
            $("div#WaterList").hide();
        } else if ($(this).is(':checked') && $(this).val() == 'Fitness') {
            $("div#FitList").show();
            $("div#WaterList").hide();
            $("div#BallList").hide();
        } else if ($(this).is(':checked') && $(this).val() == 'WaterSports') {
            $("div#WaterList").show();
            $("div#BallList").hide();
            $("div#FitList").hide();
        }
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
