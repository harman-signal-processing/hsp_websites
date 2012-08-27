xml.instruct! :xml, version: "1.0" 

xml.songs do
  @songs.each do |song|
    xml.song("title" => song.title, "url" => song.mp3.url("original", false))
  end
end
