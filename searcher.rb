# first check for incoming parameters
if ARGV.length < 2
  puts "Usage: searcher <image directory> <search directory>"
  exit
end

imageDirectory = String.new(ARGV[0])
searchDirectory = String.new(ARGV[1])

# normalize file paths, substitute \ with /
imageDirectory.gsub!("\\", "/")
searchDirectory.gsub("\\", "/")

# make paths end with trailing slashes
if not imageDirectory.end_with?("/") then
  imageDirectory.concat("/")
end

# we only do the ending-slash normalization for the search directory if it's non-empty
# if the search directory is empty, we change it to "*"
if searchDirectory.nil? or searchDirectory.length == 0 then
  searchDirectory = "*"
elsif not searchDirectory.end_with?("/") then
  searchDirectory.concat("/")
end

puts "image directory: #{imageDirectory}, search directory: #{searchDirectory}"

# collect list of images in folder
files = Dir.glob("#{imageDirectory}*.{jpg,png,gif}")
puts "found #{files.length} files"

searchTerms = {}

files.each do |fileName|
  term = File.basename(fileName)
  if searchTerms[term].nil? then
    puts "searching for \"#{term}\"..."
    output = `grep -riIn --exclude-dir=\"\\.svn\" --exclude=\"*.(vb|cs)proj\" \"#{term}\" \"#{searchDirectory}\"`
    outlines = output.split("\n")
    searchTerms[term] = outlines.length
  end
end

sortedTerms = searchTerms.sort{|a,b| a[1] <=> b[1]}
sortedTerms.each do |term| 
  puts "found \"#{term[0]}\" in #{term[1]} files"
end
