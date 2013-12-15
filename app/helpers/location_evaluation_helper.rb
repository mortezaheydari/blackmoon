module LocationEvaluationHelper


	# copy one location to the other
    def copy_locations(locatin_from, location_to)
		location_to.custom_address = locatin_from.custom_address
		location_to.custom_address_use = locatin_from.custom_address_use
		location_to.gmap_use = locatin_from.gmap_use
		location_to.gmaps = locatin_from.gmaps
		location_to.latitude = locatin_from.latitude
		location_to.longitude = locatin_from.longitude
		location_to.title = locatin_from.title
    end

	# compare two location, regardless of their specifics
    def compare_locations?(locatin_from, location_to)
		location_to.title == locatin_from.title &&
		location_to.custom_address == locatin_from.custom_address &&
		location_to.custom_address_use == locatin_from.custom_address_use &&
		location_to.gmap_use == locatin_from.gmap_use &&
		location_to.gmaps == locatin_from.gmaps &&
		location_to.latitude == locatin_from.latitude &&
		location_to.longitude == locatin_from.longitude &&
		location_to.title == locatin_from.title
    end

	def venue_location(venue_id)
		venue = Venue.find(venue_id).location
	end

	# return an offerable location
	# Note: fresh method, not used yet. To be tested in case of usage.
	def offerable_location(location_owner_type, location_owner_id)
		if location_owner = find_and_assign(location_owner_type, location_owner_id)
			location_owner.location
		else
			return false
		end
	end

    def set_params_gmaps_flag(owner_type)
      if params[owner_type][:location][:longitude].empty? || params[owner_type][:location][:latitude].empty?
        params[owner_type][:location][:gmaps] = false
      else
        params[owner_type][:location][:gmaps] = true
      end
    end

	# location evaluations for update method
	  def changing_location_parent?(owner)
	    params[:location_type] == "parent_location" && !owner.location.parent_id.nil? && owner.location.parent_id != params[:referenced_venue_id]
	  end

	  def changing_location_to_custom?
	    params[:location_type] == "custom_location" && !owner.location.parent_id.nil?
	  end

	  def changing_location_to_parent?
	    params[:location_type] == "parent_location" && owner.location.parent_id.nil?
	  end

	  def changing_custom_location?(owner)
	    return false unless params[:referenced_venue_id]
	    referenced_location = venue_location(params[:referenced_venue_id])
	    return false unless referenced_location
	    compare_locations?(owner.location, referenced_location)
	  end

end
