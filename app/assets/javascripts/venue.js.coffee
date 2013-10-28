# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    if $("input#venue_location_gmaps").attr('checked')
        $("#map_row").show()
    else
        $("#map_row").hide()
    if $("input#venue_location_custom_address_use").attr('checked')
        $("#address_row").show()
    else
        $("#address_row").hide()
    $('div.Description').hide()
    $('div.gallery').hide('fast')
    $('div.likes').hide()
    $('nav#secondary ul li:first').addClass('navActive')
  $('nav#secondary ul li#joined').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.joined').fadeIn('fast')
  $('nav#secondary ul li#Description').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.Description').fadeIn('fast')
  $('nav#secondary ul li#likes').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div.gallery').fadeOut('fast')
    $('div.likes').fadeIn('fast')
  $('nav#secondary ul li#gallery').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div.gallery').fadeIn('fast')
  $('input#venue_location_gmaps').click (e) ->
    if $(@).attr('checked')
        $("#map_row").show()
    else
        $("#map_row").hide()

  $('input#venue_location_custom_address_use').click (e) ->
    if $(@).attr('checked')
        $("#address_row").show()
    else
        $("#address_row").hide()