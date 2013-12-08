# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    $('#happening_case_date_and_time').datepicker
        format: 'yyyy-mm-dd'
    gmarkers = []
    if $("input#venue_location_gmap_use").attr('checked')
        $(".g_rows").show()
    else
        $(".g_rows").hide()
    if $("input#venue_location_custom_address_use").attr('checked')
        $("#address_row").show()
    else
        $("#address_row").hide()

    if ($(".edit_offering_session #offering_session_collective_type").val() == 'new')
        $(".edit_offering_session tr.new_collective").show()
        $(".edit_offering_session tr.existing_collective").hide()
    else if ($(".edit_offering_session #offering_session_collective_type").val() == 'existing')
        $(".edit_offering_session tr.existing_collective").show()
        $(".edit_offering_session tr.new_collective").hide()
    else if ($(".edit_offering_session #offering_session_collective_type").val() == 'none')
        $(".edit_offering_session tr.existing_collective").hide()
        $(".edit_offering_session tr.new_collective").hide()

    $('div.Schedule').show()
    $('div.Description').hide()
    $('div.gallery').hide('fast')
    $('div.likes').hide()
    $('div.Map').show()
    $('div.Map').hide()
    $("tr#repeat_row").hide()
    $('nav#secondary ul li.navActive').removeClass()
    $('nav#secondary ul li#Schedule').addClass('navActive')

    $("div.new_offering_session").hide()
    $("div.edit_offering_session").hide()


  $('a#new_offering_session').click (e) ->
    e.preventDefault()
    $("div.new_offering_session").slideDown('fast')
    $("div.edit_offering_session").slideUp('fast')

  $('a.session').click (e) ->
    e.preventDefault()
    $("form.new_offering_session")[0].reset()
    $("div.new_offering_session").slideUp('fast')
    $("div.edit_offering_session").slideDown('fast')

  $('a#edit_cancel').click (e) ->
    e.preventDefault()
    $("form.edit_offering_session")[0].reset()
    $("div.edit_offering_session").hide()

  $('a#cancel_new').click (e) ->
    e.preventDefault()
    $("form.new_offering_session")[0].reset()
    $("div.new_offering_session").hide()


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
    $('div.Schedule').fadeOut('fast')
    $('div.Map').fadeIn('fast')
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

  $('input#offering_session_collection_flag').change (e) ->
    if ($(@).is(':checked'))
        $("tr#repeat_row").show()
    else
        $("tr#repeat_row").hide()


  $('input#venue_location_gmap_use').click (e) ->
    if ($(@).is(':checked'))
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
    if ($(@).is(':checked'))
        $("#address_row").show()
    else
        $("#address_row").hide()