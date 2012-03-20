def clean_file(file)
  return unless File.file?(file)
  c = File.read(file)
  c.gsub!(/[ \t]+\n/, "\n")
  c.gsub!(/\Z/, "\n") unless c =~ /\n\Z/
  File.open(file, 'w'){|io|
    io << c
  }
end

Dir["**/*.rb"].each{|file| clean_file(file)}
Dir["public/js/logbook.js"].each{|file| clean_file(file)}
Dir["**/*.yml"].each{|file| clean_file(file)}
Dir["**/*.md"].each{|file| clean_file(file)}
Dir["**/*.coffee"].each{|file| clean_file(file)}
