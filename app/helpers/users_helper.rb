module UsersHelper
	def gravatar_for(user, options = {size: 50, css_class: ""})
		gravatar_id = Digest::MD5::hexdigest(user.account.email.downcase)
		size = options[:size]
                      size = 50 if size == :small
		css_class = options[:css_class]
		gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, als: user.name, class: "gravatar #{css_class}")
	end

end
