
local apms = require 'apms'

local request_data
request_data = apms:get("27.6.2016", "Radenci", "Maribor AP")

for _,v in ipairs(request_data) do
  print(v.station, v.at)
end

request_data = apms:get({27,6,16}, "Radenci", "Maribor AP")

for _,v in ipairs(request_data) do
  print(v.station, v.at)
end
