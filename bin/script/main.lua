require("script.util.http")

function start()
	local function process_callback( clientp,dltotal,dlnow,ultotal,ulnow )
		print(dlnow)
	end
	--HTTP.DownLoadFile("a/lua.zip","localhost/lua.zip",process_callback)
	--print(HTTP.Visit("localhost"))
	local file=io.open('a\\a.txt',"wb")
	for k,v in pairs(os) do
		print(k,v)
	end
end
function Update()

end

