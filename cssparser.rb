require 'rubygems'
require 'css_parser'

include CssParser

filePath = ARGV[0]
searchDirectory = ARGV[1]
puts "CSS file: #{filePath}, search directory: #{searchDirectory}"

if searchDirectory.nil? or searchDirectory.length == 0 then
  searchDirectory = "*"
end

parser = CssParser::Parser.new
parser.load_file!(filePath)

parser.each_selector do |selector, declarations, specificity|
  matches = selector.scan(/\.([a-z0-9\-_]+)/i)
  if matches.length > 0 then
    matches.each do |match|
      print "searching for \"#{match[0]}\"..."
      match[0].gsub!("-", "\\-")
      output = `grep -riIn --exclude-dir=\"\\.svn\" --exclude=\"*.css\" #{match[0]} \"#{searchDirectory}\"`
      outlines = output.split("\n")
      print output == "" ? "not found" : "found #{outlines.length} times"
      print "\n"
    end
  end
end
