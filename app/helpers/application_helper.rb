module ApplicationHelper
	def logo
		image_tag("logo.png", alt: "Moogle")
	end

	def full_title(page_title)
		site_title = 'Moogle'
		if page_title.empty?
			site_title
		else
			"#{site_title} | #{page_title}"
		end
	end
end
