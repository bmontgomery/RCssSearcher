require 'rubygems'
require 'css_parser'

include CssParser

filePath = ARGV[0]

parser = CssParser::Parser.new
parser.load_file!(filePath)

parser.each_selector do |selector, declarations, specificity|
  matches = selector.scan(/\.([a-z0-9-_]+)/i)
  if matches.length > 0 then
    matches.each do |match|
      puts match
    end
  end
end

# now we need to look in a certain directory, at certiain file types, and see if each class is used. if it's not, let the user know they can most likely get rid of it
