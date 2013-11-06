# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    gmarkers = []
    if $("input#venue_location_gmap_use").attr('checked')
        $(".g_rows").show()
    else
        $(".g_rows").hide()
    if $("input#venue_location_custom_address_use").attr('checked')
        $("#address_row").show()
    else
        $("#address_row").hide()
    $('div.Map').hide()
    $('div.Description').hide()
    $('div.gallery').hide('fast')
    $('div.likes').hide()
    $('nav#secondary ul li:first').addClass('navActive')


  $('nav#secondary ul li#Schedule').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.Schedule').fadeIn('fast')
    $('div.Map').fadeOut('fast')


  $('nav#secondary ul li#Map').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.Map').fadeIn('fast')
    $('div.Schedule').fadeOut('fast')
    google.maps.event.trigger(map, 'resize')


  $('nav#secondary ul li#Description').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Map').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.Description').fadeIn('fast')
    $('div.Schedule').fadeOut('fast')


  $('nav#secondary ul li#likes').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Map').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.likes').fadeIn('fast')
    $('div.Schedule').fadeOut('fast')


  $('nav#secondary ul li#gallery').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Map').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeIn('fast')
    $('div.Schedule').fadeOut('fast')


  $('input#venue_location_gmap_use').click (e) ->
    if $(@).attr('checked')
        $(".g_rows").show()
        $("#venue_location_latitude").show()
        $("#venue_location_longitude").show()
        google.maps.event.trigger(map, 'resize')
    else
        $(".g_rows").hide()
        $("#venue_location_latitude").val("")
        $("#venue_location_longitude").val("")
        $("#venue_location_latitude").hide()
        $("#venue_location_longitude").hide()

  $('input#venue_location_custom_address_use').click (e) ->
    if $(@).attr('checked')
        $("#address_row").show()
    else
        $("#address_row").hide()