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
//= require jquery.ui.datepicker
//= require fancybox
//= require underscore
//= require gmaps/google
//= require bootstrap
//= require jquery-fileupload
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

window.onload = function(){
    SI.Files.stylizeAll();
}




$(document).ready(function() {
    var $modal = $('#modal');
    var $modal_close = $modal.find('.close');
    var $modal_container = $('#modal-container');
    $("ul#userDrop").hide();
    $('ul#ExploreDrop').hide();
    $("#BallList").show();
    $("#FitList").hide();
    $("#FitList select").attr('name', '');
    $("#WaterList select").attr('name', '');
    $("#WaterList").hide();
    $("tr#AmountRow").hide();
    $("tr.ptdata").hide();
    $("tr.cldata").hide();
    $("tr.vndata").hide();
    $("tr.evdata").hide();
    $("tr.gmdata").hide();
    $("tr.tmdata").hide();
    $('#previewImg').hide();

    $("tr.allday").show();
    $("tr.range").hide();

    $("tr.existing_collective").hide();
    $("tr.new_collective").hide();

    $(".btn-group").hide();

    $('.gender').tooltip();
    $('.team').tooltip();
    $('.solo').tooltip();
    $('a').tooltip();


     $('.activityOrigin').css({
         height: $('.eventProfileCard').css('height')
     });
     $('.stats').css({
         height: $('.UserProfileCard').css('height')
     });
// check select cat radiobutton

    if ($("#team_category_ballsports").is(':checked')) {
            $("div#BallList").show();
            $("#BallList select").attr('name', 'team[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
    } else if ($("#team_category_fitness").is(':checked')) {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'team[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
    } else if ($("#team_category_watersports").is(':checked')) {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'team[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
    }


    if ($("#game_category_ballsports").is(':checked')) {
            $("div#BallList").show();
            $("#BallList select").attr('name', 'game[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
    } else if ($("#game_category_fitness").is(':checked')) {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'game[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
    } else if ($("#game_category_watersports").is(':checked')) {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'game[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
    }

    if ($("#event_category_ballsports").is(':checked')) {
            $("div#BallList").show();
            $("#BallList select").attr('name', 'event[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
    } else if ($("#event_category_fitness").is(':checked')) {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'event[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
    } else if ($("#event_category_watersports").is(':checked')) {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'event[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
    }
// check select cat radiobutton



    $("a#SignInTop").click(function(e) {
        e.preventDefault();
        $("#SignIn").modal();
    });

    $("a#SignUpTop").click(function(e) {
        e.preventDefault();
        $("#SignUp").modal();
    });

    $('input.file').change(function() {
        $("p#fileName").text(this.value);
    });

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

    $("div#createNewMenu a").click(function(e) {
        e.preventDefault();
        $("#Create").modal();
    });


    // $("div#Sign a#SignInTop").fancybox({
    //     padding: 0,
    //     margin: 0,
    //     minWidth: 600
    // });

    // $("div#Sign a#SignUpTop").fancybox({
    //     padding: 0,
    //     margin: 0,
    //     minWidth: 600
    // });


function readURL(input) {

    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#previewImg').attr('src', e.target.result);
            $('#previewImg').css({
                width: 50,
                height: 50
            });
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#fileupload").change(function(){
    $('#previewImg').show();
    readURL(this);
});



    $("div.gallery a.imageModal").fancybox({
        padding: 0,
        margin: 0,
        minWidth: 400
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

    $("input[name='game[category]']").imageTick({
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


    $("input[name='team[category]']").imageTick({
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
            $("#BallList select").attr('name', 'event[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'Fitness') {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'event[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'WaterSports') {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'event[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
        }
    });


    $("span .withoutHour").attr('name', 'offering_session[repeat_duration]');
    $("span.withoutHour").show();
    $("span .withHour").attr('name', '');
    $("span.withHour").hide();

    $("#happening_case_duration_type").change( function() {
        if ($(this).val() == 'All Day') {
            $("tr.allday").show();
            $("tr.range").hide();
            $("span .withoutHour").attr('name', 'offering_session[repeat_duration]');
            $("span.withoutHour").show();
            $("span .withHour").attr('name', '');
            $("span.withHour").hide();
        } else if ($(this).val() == 'Range') {
            $("tr.range").show();
            $("span .withHour").attr('name', 'offering_session[repeat_duration]');
            $("span.withHour").show();
            $("span .withoutHour").attr('name', '');
            $("span.withoutHour").hide();
        }
    });

    $("a.collective_label").click(function(e) {
        e.preventDefault();
        $(".btn-group").show();
        $('li a.active_collective').removeClass('active_collective');
        $('span.label-info').removeClass('label-info');
        $("a#" + this.id + " span").addClass('label-info');
        $("li a." + this.id).addClass('active_collective');
        $("li a#explode_collective").attr('href', $("li a#explode_collective").attr('href') + "&collective_id=" + $("span.label-info").attr('data-id'));
        $("li a#delete_collective").attr('href', $("li a#delete_collective").attr('href') + "&collective_id=" + $("span.label-info").attr('data-id'));
    });

    $("#offering_session_collective_type").change( function() {
        if ($(this).val() == 'new') {
            $("tr.new_collective").show();
            $("tr.existing_collective").hide();
        } else if ($(this).val() == 'existing') {
            $("tr.existing_collective").show();
            $("tr.new_collective").hide();
        }  else if ($(this).val() == 'none') {
            $("tr.existing_collective").hide();
            $("tr.new_collective").hide();
        }
    });


    $("input:radio[name='game[category]']").change( function() {
        if ($(this).is(':checked') && $(this).val() == 'BallSports') {
            $("div#BallList").show();
            $("#BallList select").attr('name', 'game[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'Fitness') {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'game[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'WaterSports') {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'game[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
        }
    });

    $("input:radio[name='team[category]']").change( function() {
        if ($(this).is(':checked') && $(this).val() == 'BallSports') {
            $("div#BallList").show();
            $("#BallList select").attr('name', 'team[sport]');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'Fitness') {
            $("div#FitList").show();
            $("#FitList select").attr('name', 'team[sport]');
            $("div#WaterList").hide();
            $("#WaterList select").attr('name', '');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
        } else if ($(this).is(':checked') && $(this).val() == 'WaterSports') {
            $("div#WaterList").show();
            $("#WaterList select").attr('name', 'team[sport]');
            $("div#BallList").hide();
            $("#BallList select").attr('name', '');
            $("div#FitList").hide();
            $("#FitList select").attr('name', '');
        }
    });

    $("#event_fee_type").change( function() {
        if ($(this).val() == 'Free') {
            $("tr#AmountRow").hide();
        } else if  ($(this).val() == 'Cash') {
            $("tr#AmountRow").show();
        }
    });
    $("#game_fee_type").change( function() {
        if ($(this).val() == 'Free') {
            $("tr#AmountRow").hide();
        } else if  ($(this).val() == 'Cash') {
            $("tr#AmountRow").show();
        }
    });

    $("td#ptType").click(function(e) {
        e.preventDefault();
        img = $("td#ptType img.drop");
        $("tr.ptdata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
        }
    });

    $("td#clType").click(function(e) {
        e.preventDefault();
        img = $("td#clType img.drop");
        $("tr.cldata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
        }
    });

    $("td#vnType").click(function(e) {
        e.preventDefault();
        img = $("td#vnType img.drop");
        $("tr.vndata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
        }
    });

    $("td#evType").click(function(e) {
        e.preventDefault();
        img = $("td#evType img.drop");
        $("tr.evdata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
        }
    });

    $("td#gmType").click(function(e) {
        e.preventDefault();
        img = $("td#gmType img.drop");
        $("tr.gmdata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
        }
    });

    $("td#tmType").click(function(e) {
        e.preventDefault();
        img = $("td#tmType img.drop");
        $("tr.tmdata").fadeToggle("fast");
        if (img.attr("src") != "/assets/up-icon.png") {
            img.attr("src", "/assets/up-icon.png");
        } else {
            img.attr("src", "/assets/drop-icon.png");
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
