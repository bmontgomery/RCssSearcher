require 'rubygems'
require 'css_parser'

include CssParser

parser = CssParser::Parser.new
parser.load_file!('test.css')

parser.each_selector() do |selector, declarations, specificity|
  puts selector if /^\./.match(selector)
end
