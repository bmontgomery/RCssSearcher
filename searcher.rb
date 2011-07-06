imageDirectory = String.new(ARGV[0])
searchDirectory = ARGV[1]
imageDirectory.gsub!("\\", "/")
puts "image directory: #{imageDirectory}, search directory: #{searchDirectory}"

if searchDirectory.nil? or searchDirectory.length == 0 then
  searchDirectory = "*"
end

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
