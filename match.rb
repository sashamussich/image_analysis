#!/usr/bin/env ruby

require_relative 'image_matcher/image_matcher.rb'

#folder where are located images to compare 
current_dir = File.expand_path File.dirname __FILE__
image_dir = File.join current_dir, 'images'

#images to be compared 
images = [
	['parot.png', 'template.png']
]

images.each_with_index do |pair, i|
	puts 
	puts "------------ Image Pair #{i+1} ------------"
	puts "Does '#{pair[0]}' contain '#{pair[1]}'??"

	full_image_path = File.join image_dir, pair[0]
	puts "*******" + full_image_path
	template_image_path = File.join image_dir, pair[1]

	image_matcher = ImageMatcher.new
	image_matcher.full_image  = full_image_path
	image_matcher.template_image = template_image_path
	image_matcher.verbose = true
	image_matcher.strategy = 'full'
	image_matcher.fuzz = 0.0
	image_matcher.highlight_match = true #prints the template on the full image to see it
	image_matcher.match!

	if image_matcher.match?
		puts "\n Yes. Matches at: " + image_matcher.match_result.join 
	else
		puts "\n No match."
	end

	puts "\n Search time using '#{image_matcher.strategy}': #{image_matcher.benchmark.total} seconds \n"

	puts "-" * 25
	puts 
end