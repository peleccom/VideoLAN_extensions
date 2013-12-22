--[[
	Playlist extension for audio.telecom.by
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
        and string.find( vlc.path, "audio.telecom.by" )
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
	id = string.match(html, 'id="downitem" value="([^"]*)"')
	vlc.msg.info(id)
	-- TODO: Randomize rand parameter
	url = "http://audio.telecom.by/_modules/_caudiocat/globalajax.php?rand=fG1eqOIRBBXKfSiS01uo1cyIDRa1G6N&mode=files&item_id="..id
	vlc.msg.info(url)
	s = vlc.stream(url)
	local html = ''
	while true do
		local line = s:readline()
		if not line then break end
		html = html .. line
	end
	vlc.msg.info(html)
	for title in string.gmatch(html, "<h5>([^<]*)</h5>") do
		table.insert(titles, title)
	end
	for file_url in string.gmatch(html, "&file=([^&]*)&") do
		path = "http://audio.telecom.by" .. file_url
		title = table.remove(titles, 1)
		table.insert(p, {path=path; title=title; description=path })
	end
	return p
  end
 
