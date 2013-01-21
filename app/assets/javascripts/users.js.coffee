# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    $('div.intrestCat').hide()
    $('div.cards').hide()
    $('nav#secondary ul li:first').addClass('navActive')
  $('div.dashboard a#editIntrest').click (e) ->
    e.preventDefault()
    $('div.intrestCat').slideToggle()
  $('nav#secondary ul li#activities').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.cards').fadeOut('fast')
    $('div.activityCards').fadeIn('fast')
  $('nav#secondary ul li#players').click (e) ->
    e.preventDefault()
    $('nav#secondary ul li.navActive').removeClass()
    $(@).addClass('navActive')
    $('div.activityCards').fadeOut()
    $('div.cards').fadeIn()