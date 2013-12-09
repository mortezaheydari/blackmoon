## Controllers

### Essential Controllers
Behaving restful, These controllers handle most essential objects of the website while recording their activity using PublicActivity gem.
Essential objects are known as "actors" and "offerings" in original project planning documents.

**user_controller.rb**

Controlling user pages, handles a typical and conventional load. This is because if separating Devise object under name of (account) from project specific functionalities of user.

**game_controller.rb & event_controller.rb**

Being highly similar in functionality, they handle _restful actions_ plus _like_ which is backed by flaggable gem.

**venue_controller.rb**

Venue being an offering, makes the controller similar to game and event controller. Difference is in handling offering_sessions and calendar, and the fact that venue don't have a happeing_case.

**team_controller.rb**

At the time being (20131209), this controller works highly similar to event and game. However, team object being a MoonActor might open specific change possibilities in future.

**offering_sessions_controller.rb**

Handling an essential object, this controller is listed among essential controllers. 
Yet this one works less restful than others. This is because of the object being partially controlled by multi-session essential object that owns is (exp: venue). 

### Butterfly Controllers
These are responsible for interactions between "Essential Interactions" between actors and offerings. 
They only handle create and destroy actions, with their view folder almost empty (except for few js files):

* **act_memberships_controller.rb**
* **act_memberships_controller.rb**
* **offering_administrations_controller.rb**
* **offering_individual_participations_controller.rb**
* **offering_team_participations_controller.rb**

### Supporting Controllers

**activities_controller.rb**

Connected to PublicActivity gem, currently (20131209) only renders public activities on website root page.

**invitations_controller.rb**

Backed with PublicActivity gem, manages creation on update of invitation sent and received between users.
Sending new invitation is handled by _create_ method, while _update_ handles invitation response process.
Since invitations are created as PublicActivity object, they are easily accessible in notification and log lists.

**happening_cases_controller.rb**

Since happening_case objects gets created and destroyed within other controllers, only action handled here is update of time-date property.

**logos_controller.rb**

Like happening_case, only action here is update. 

**album_photos_controller.rb**

Responsibility of this controller is to create, update destroy on album_photo object, assigning photo objects to album objects. Same controller is also responsible for creating photo objects and destroying them in case they are not used by any album or logo.

**relationship_controller.rb**

Allows users to follow each other.

**page_controller.rb**

Handles static pages.

## Helpers guide

This section explains those code behaviors that are project specific and in cases might seem (and be) alien or unconventional.
Scope of this section is limited to controllers behavior.

### name_is_valid?

checking if given name is acceptable within scope that method is defined, different versions of this method can be found across the code that looks like the following:

```ruby
	def name_is_valid?(name)
	  ["event","class","game", "user", "team", "venue"].include? name.underscore
	end
```
It might also evaluate if user responds to an specific method related to the given name.

Currently (20131209), method can be found is:
0.	application_controller.rb
1.	act_administrations_controller.rb
2.	act_memberships_controller.rb
3.	offering_administrations_controller.rb
4.	offering_individual_participations_controller.rb
5.	offering_team_participations_controller.rb


### double_check

This method is specific to controllers. Checking a condition, it will redirect user to a given page (root by default) and terminates the process of controller. 
current version of method (version-20131023) is as follows:

```ruby
def double_check(link=root_path, msg='there was an error with your request', &b)
	link == @redirect_object unless @redirect_object.nil?
	redirect_to(link, alert: msg) and return false unless b.call
end
```
Following helper methods are influenced with double_check and name_is_valid:

1. **double_check_name_is_valid**: mix of name_is_valid? and double_check functionality.
3. **this_if_reachable**: validates received name, performs a double_check on process of finding the requested object.
4. **owner_if_reachable**: similar to this_if_reachable, used to find owner and return of the requested object.

