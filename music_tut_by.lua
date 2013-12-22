--[[
	Playlist extension for  music.tut.by
	Version: 1.0
--]]

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end

-- Probe function.
function probe()
    return vlc.access == "http"
        and string.find( vlc.path, "music.tut.by" )
end

-- Parse function.
function parse()
	p = {}
	titles = {}
	local html = ''
	while true do
		local line = vlc.readline()
		if not line then break end
		html = html .. line
	end
	html = vlc.strings.from_charset("windows-1251", html)
	return parse_mp3_page(html)
  end
 
 function parse_mp3_page(html)
	path = string.match(html, '\"(\/mini\.php\[^"]*)\"')
	title = string.match(html, '<h1>([^<]*)</h1>')
	artist = string.match(html, '<a href\=\"\/artist\/%d*\">([^<]*)</a>')
	genre = string.match(html, 'class\=\"audio--track--tag\">([^<]*)</a>')
	if path then
		path = "http://music.tut.by" .. path 
		return { {path=path; title=title;artist=artist; genre=genre; description=path} }
	end
	
 end
