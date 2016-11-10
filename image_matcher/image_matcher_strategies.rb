module ImageMatcherStrategies

	@@strategies = {
		'full' => :match_position_by_full_string,
		'rows' => :match_position_by_pixel_rows,
		'pixels' => :match_position_by_pixel_strings
	}

	private

	#compare images by converting all pixels to string 
	def match_position_by_full_string
		t_width = template_image.columns 
		t_hight = template_image.rows
		#template image is exported as string
		t_pixel_string = template_image.export_pixels_to_str(0, 0, t_width, t_hight)

		catch :found_match do
			search_rows.times do |y|
				search_cols.times do |x|
					puts "Searching full image at #{x} , #{y}" if @verbose

					full_pixel_string = full_image.export_pixels_to_str(x, y, t_width, t_hight)

					if full_pixel_string == t_pixel_string
						self.match_result = x, y
						throw :found_match #break out of loops
					end
				end
			end
		end
		return match_result
	end

	def match_position_by_pixel_rows
	end

	def match_position_by_pixel_strings
	end
end