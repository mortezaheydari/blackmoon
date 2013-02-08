module UsersHelper
	def gravatar_for(user, options = {size: 50, gravatar_class: ""})
		gravatar_id = Digest::MD5::hexdigest(user.account.email.downcase)
		size = options[:size]
                      gravatar_class = options[:gravatar_class]
		gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, als: user.name, class: "gravatar #{gravatar_class}")
	end
end
