module UsersHelper
 def gravatar_for(user, size: 80, cl: "")
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    if !cl.nil?
    	image_tag(gravatar_url, alt: user.name, class: cl)
    else
    	image_tag(gravatar_url, alt: user.name)
    end

  end	
end
