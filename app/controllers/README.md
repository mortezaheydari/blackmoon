# Information

This Readme explains some code behaviors that are project specific and in cases might seem (and be) alien or unconventional.
Scope of this page is limited to controllers behavior.

## name_is_valid?

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


## double_check

This method is specific to controllers. Checking a condition, it will redirect user to a given page (root by default) and terminates the process of controller. 
current version of method (version-20131023) is as follows:

```ruby
def double_check(link=root_path, msg='there was an error with your request', &b)
	link == @redirect_object unless @redirect_object.nil?
	unless b.call
		return redirect_to(link, alert: msg)
	end
end
```
Following helper methods are influenced with double_check:

### double_check_name_is_valid

mix of name_is_valid? and double_check functionality.

### find_and_assign

finds and assign an object, while performing a custom version of name_is_valid and double_check.

### this_if_reachable

validates received name, performs a double_check on process of finding the requested object.

### owner_if_reachable

similar to this_if_reachable, used to 