# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).ready ->
    $(".location_partial_container").hide()
    if $( "select#location_type option:selected").attr('value') == "custom_location"
        $(".venue_list ").hide()
        $(".location_partial_container ").show()
        google.maps.event.trigger(map, 'resize')
    else if $( "select#location_type option:selected").attr('value') == "referenced_location"
        $(".location_partial_container ").hide()
        $(".venue_list ").show()


    $('#location_type').change (e) ->
        if $( "select#location_type option:selected").attr('value') == "custom_location"
            $(".venue_list ").hide()
            $(".location_partial_container ").show()
            google.maps.event.trigger(map, 'resize')
        else if $( "select#location_type option:selected").attr('value') == "referenced_location"
            $(".location_partial_container ").hide()
            $(".venue_list ").show()