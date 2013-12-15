# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    $('div.Description').show()
    $('div.joined').hide()
    $('div#gallery_container').hide('fast')
    $('div.likes').hide()
  $('nav#secondary ul li#joined').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div#gallery_container').fadeOut('fast')
    $('div.joined').fadeIn('fast')
  $('nav#secondary ul li#Description').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div#gallery_container').fadeOut('fast')
    $('div.Description').fadeIn('fast')
  $('nav#secondary ul li#likes').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div#gallery_container').fadeOut('fast')
    $('div.likes').fadeIn('fast')
  $('nav#secondary ul li#gallery').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.joined').fadeOut('fast')
    $('div.Description').fadeOut('fast')
    $('div.likes').fadeOut('fast')
    $('div#gallery_container').fadeIn('fast')