
local requests = require 'requests'
local cjson = require 'cjson'

local apms = {}

apms.url_template = "http://www.apms.si/response.ajax.php?com=voznired&task=get&datum=%s&postaja_od=%s&postaja_do=%s"

-- helper functions
local function repair_year(val)
  if val < 2000 then return val + 2000 end
  return val -- else
end

function apms:get(date, from, to)
  local d -- first handle the date
  if type(date) == "table" then d = string.format("%d.%d.%d", date[1],date[2],repair_year(date[3])) end
  if type(date) == "string" then d = date end
  local st = { -- stations
    string.gsub(from, " ", "+"),
    string.gsub(to, " ", "+")
  }
  local res = requests.get(string.format(self.url_template, d, st[1], st[2]))
  if res.status_code ~= 200 then return res.status_code, "STATUS" end
  local decoded = cjson.decode(res.text)
  local out = {}
  for _, v in ipairs(decoded) do
    for _, p in ipairs(v.potek_voznje) do
      if from == p.postajalisce then
        table.insert(out, {
          ['station'] = p.postajalisce,
          ['at'] = p.odhod
        })
      end
    end
  end
  return out
end

return apms
