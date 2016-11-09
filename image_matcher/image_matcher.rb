require 'RMagic'
include Magick 
require 'benchmark' #ruby standard lib

require_relative 'image_matcher_strategies'

class ImageMatcher 

	attr_reader :full_image, :template_image
	attr_reader :match_x, :match_y, :benchmark
	attr_reader :search_cols, :search_rows
	attr_accessor :strategy, :verbose, :highlight_match, :fuzz

	@@strategies = {}


end