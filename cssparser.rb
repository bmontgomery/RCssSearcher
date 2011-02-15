require 'rubygems'
require 'css_parser'

include CssParser

filePath = ARGV[0]

parser = CssParser::Parser.new
parser.load_file!(filePath)

parser.each_selector() do |selector, declarations, specificity|
  puts selector if /^\./.match(selector)
end
