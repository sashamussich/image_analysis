require 'rmagick' ; include Magick 
require 'benchmark' #ruby standard lib

require_relative 'image_matcher_strategies'

class ImageMatcher 

	attr_reader :full_image, :template_image
	attr_reader :match_x, :match_y, :benchmark
	attr_reader :search_cols, :search_rows
	attr_accessor :strategy, :verbose, :highlight_match, :fuzz

	@@strategies = {}

	include ImageMatcherStrategies

	def initialize options = {}
		full_image = options[:full_image]
		template_image = options[:template_image]
		@strategy = options[:strategy]
		@verbose = options[:verbose] === false ? false : true
		@highlight_match = options[:verbose] || false
		@fuzz = options[:fuzz] || 0.0
	end

	#takes the path of full image and reads image data using ImageMagic
	#also sets number of cols and rows of whole image 
	def full_image= filepath
		@full_image = read_image filepath
		@search_cols = full_image.columns
		@search_rows = full_image.rows
		return full_image
	end

	def template_image= filepath
		@template_image = read_image filepath
	end

	#returns true if matching coordinates have been found
	def has_match?
		!match_x.nil? && !match_y.nil?
	end

	#retuns upper-left coordinates of match as an array 
	def match_result 
		[match_x, match_y]
	end

	#clears any previous match result
	def clear!
		@match_x = nil
		@match_y = nil
	end

	#perform match on current configuration, uses benchmark to record the time gone while matching,
	#returnes true if match found
	def match!
		clear! #deleting old results if any
		tighten_search_area
		@benchmark = Benchmark.measure do #measure to see how long takes strategy to process
			send strategy_method
		end
		save_match_file if highlight_match #saves img with highlight
		return has_match?
	end

	private 

	#use Image<magick to read in the image file
	def read_image filename
		return Magick::Image.read(filename).first if filename
	end

	#shrinks the area that needs to be searched, we dont need to search full image, 
	#when remaining rows are less than the template image has - template wouldnt fit anyways and we can break
	def tighten_search_area
		@search_cols = full_image.columns - template_image.columns
		@search_rows = full_image.rows - template_image.rows
	end

	#
	def add_fuzz_to_images
	end

	#use @strategy string to get method name of strategy which is a symbol from hash @@strategies
	def strategy_method 
		if @@strategies.size == 0 
			puts "No strategies defined"
			exit
		end
		strategy_method = @@strategies[strategy]

		raise "Invalid strategy" if strategy_method.nil?
		return strategy_method
	end

	#sets match values for @match_x and @match_y when an array is passed to as argument
	def match_result= array
		@match_x, @match_y = array if array && array.is_a?(Array)
	end

	#save a copy of full image with match area highlighted
	def save_match_file
		if match_x && match_y
			end_x = match_x + template_image.columns
			end_y = match_y + template_image.rows

			area = Magick::Draw.new
			area.fill 'none'
			area.stroke 'red'
			area.stroke_width 3
			area.rectangle match_x, match_y, end_x, end_y
			area.draw full_image
			full_image.write matchfile
		else 
			raise "No match found"
		end
	end

	#makes the name for matchfile
	def matchfile
		if full_image
			name_parts = full_image.filename.split '.'
			ext = name_parts.pop
			name = name_parts.join "."
			return "#{name}_match.#{ext}"
		else
			return "no_search_image.png"
		end
	end

end