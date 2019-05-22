module ApplicationHelper
	def full_title(page_title = '')
		base_title = "Adrian"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end

	def current?(key, path)
		"#{key}" if current_page? path
	end


end
