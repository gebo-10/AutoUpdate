require("script.util.http")
require("manifest")
require("script.util.serialize")
function start()
	local remote_version=HTTP.Visit(Config.http_host.."version.txt")
	print(remote_version)
	remote_version=loadstring(remote_version)
	remote_version=remote_version()
	local version_file=io.open("version.lua","r+")
	local local_version={}
	if version_file ~= nil then
		local tmp=version_file:read("*all")
		version_file:close()
		local_version=loadstring(tmp)
		local_version=local_version()
		if local_version == nil then
			local_version={}
		end
		print(local_version)
	end
	local update_list={}

	for k,v in pairs(remote_version) do
		print(k,v.type,v.md5)
		if local_version[k] ~= nil and local_version[k].md5 == v.md5 then
			--放空
		elseif v.type == 1 then
			--文件
			local function process_callback( clientp,dltotal,dlnow,ultotal,ulnow )
				print(dlnow)
			end
			print("start DownLoadFile"..k)
			HTTP.DownLoadFile(tostring(k),Config.http_host..tostring(k),process_callback)
			local_version[k]={}
			local_version[k].type=v.type
			local_version[k].md5=v.md5
		elseif v.type==2 then
			-- 目录
			os.execute("mkdir "..tostring(k))
			local_version[k]={}
			local_version[k].type=v.type
			local_version[k].md5=v.md5
		end
		
	end
	print(serialize(local_version))
	
	--HTTP.DownLoadFile("a/lua.zip","localhost/lua.zip",process_callback)
	--print(HTTP.Visit("localhost"))
	
end
function Update()

end