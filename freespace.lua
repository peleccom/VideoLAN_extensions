--[[
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
        and string.find( vlc.path, "freespace.by" )
end

-- Parse function.
function parse()
local html = ''
 while true do
            local line = vlc.readline()
            if not line then break end
            html = html .. line
  end
  path = string.match(html, 'file":"([^"]*.flv)"')
  title = string.match(html, 'comment":"([^"]*)"')
  if path then
    path = url_decode(path)
    return { { path = path; title = title; description = vlc.path} }
    end
  return {}
  end
 
