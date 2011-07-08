=begin

= NAME
searcher.rb
A script for determining unused image files

= SYNOPSIS
This script serves as a wrapper around grep for determining unused (JPEG, PNG, or GIF) image files by searching for references to them in plain text.
The first (required) parameter provided is the path to the image directory.
The second parameter provided is the path to the search directory.  If this parameter is omitted, it defaults to '.'.

=end

# check if end_with? is defined - if not, define it here
if not String.respond_to?('end_with?') then
	class String 
		def end_with? (substr)
			!self.match(/#{Regexp.escape(substr)}$/).nil?		
		end
	end
end

# first check that at least an image directory was provided
if ARGV.length < 1 then
  puts "Usage: searcher <image directory> [search directory]"
  exit
end

# load in arguments
imageDirectory = String.new(ARGV[0])
# if search directory is not provided, default to .
if ARGV.length > 1 then
  searchDirectory = String.new(ARGV[1])
else
  searchDirectory = "."
end

# normalize file paths, substitute \ with /
imageDirectory.gsub!("\\", "/")
searchDirectory.gsub!("\\", "/")

# make image directory path end with a trailing slash
if not imageDirectory.end_with?("/") then
  imageDirectory.concat("/")
end

# however, the search directory path should not end with a trailing slash
if searchDirectory.end_with?("/") then
  searchDirectory.sub!(/\/+$/, '')
end

puts "Image directory: #{imageDirectory}"
puts "Search directory: #{searchDirectory}"

# collect list of images in folder
files = Dir.glob("#{imageDirectory}*.{jpg,jpeg,png,gif}")
puts "Found #{files.length} files"

searchTerms = {}

files.each do |fileName|
  term = File.basename(fileName)
  if searchTerms[term].nil? then
    puts "Searching for \"#{term}\"..."
    output = `grep -riIn --exclude-dir=\"/.svn\" --exclude=\"*.(vb|cs)proj\" \"#{term}\" \"#{searchDirectory}\"`
    outlines = output.split("\n")
    searchTerms[term] = outlines.length
  end
end

sortedTerms = searchTerms.sort{|a,b| a[1] <=> b[1]}
sortedTerms.each do |term| 
  puts "found \"#{term[0]}\" in #{term[1]} files"
end
