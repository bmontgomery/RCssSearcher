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

searchTerms = {}

parser.each_selector do |selector, declarations, specificity|
  matches = selector.scan(/\.([a-z0-9\-_]+)/i)
  if matches.length > 0 then
    matches.each do |match|
      term = String.new(match[0])
      if searchTerms[term].nil? then
        puts "searching for \"#{term}\"..."
        match[0].gsub!("-", "\\-")
        output = `grep -riIn --exclude-dir=\"\\.svn\" --exclude=\"*.css\" #{match[0]} \"#{searchDirectory}\"`
        outlines = output.split("\n")
        searchTerms[term] = outlines.length
      end
    end
  end
end

sortedTerms = searchTerms.sort{|a,b| a[1] <=> b[1]}
sortedTerms.each do |term| 
  puts "found \"#{term[0]}\" in #{term[1]} files"
end
