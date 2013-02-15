--VERSION=1.0.0_Normal
local function getList()
    local file = ""
    if http then
        file = http.get( "https://raw.github.com/Thomasims/ImefOS_UAddons/master/fileslist") or "No Connection to GitHub"
    else
        file = "return"
    end
    return file
end

local function explode(str, l)
  local returned = {}
  local lastT = 1
  for i = 1, str:len() do
    if str:sub(i, i + l:len() - 1) == l then
      returned[#returned + 1] = str:sub(lastT, i -1 )
      lastT = i + l:len()
    end
  end
  returned[#returned+1] = str:sub(lastT, str:len())
  return returned
end

local toD = explode(getList(), "(&@)")
if getList() == "return" then
  return
end
local stats = {}
if getList() ~= "No connection to GitHub" then
for i = 1, #toD do
    if fs.exists(toD[i]) then
        local ttl = fs.open(toD[i])
        local tmp = fs.open(".tmpdwnlfile","w")
        local dwnl = http.get( "https://raw.github.com/Thomasims/ImefOS_UAddons/master/toD[i])
        tmp.write(dwnl)
        tmp.close()
        local tmp = fs.open(".tmpdwnlfile")
        if tmp.readLine() == ttl.readLine() then
          stats[#stats+1] = "up to date"
        else
          stats[#stats+1] = "out of date"
        end
        tmp.close()
        ttl.close()
        fs.delete(".tmpdwnlfile")
      else
        stats[#stats+1] = "not downloaded"
      end
  end
end
end

local t = {
  button.new(20, 4, "Download", colors.yellow)
  listBox.new(3, 4, 16, 8, toD)
  label.new(20, 6, "", colors.black)
}

local f = {
  function()
    local sel = t[2].sel
    local filet = http.get( "https://raw.github.com/Thomasims/ImefOS_UAddons/master/"..t[2].t[sel])
    if filet then
    local hndl = fs.open(t[2].t[sel], "w")
    hndl.write(filet)
    hndl.close()
    else
      --it failed
    end
  end,
  function()
    t[3].str = stats[t[2].t[t.sel]]
  end,
  nil
}

open_app = app.new(window.new(1, 1, 30, 10, "Thom's addons updater",  drawOS, true), t, f)