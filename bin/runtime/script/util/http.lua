local ffi = require('ffi')                    
ffi.cdef[[ 
    typedef size_t (__cdecl *curl_write_callback)(char *buffer,size_t size,size_t nitems,void *outstream);
    typedef int (__cdecl *curl_progress_callback)(void *clientp,double dltotal,double dlnow,double ultotal,double ulnow);
    void *curl_easy_init();
    int curl_easy_setopt(void *curl, int option, ...);
    int curl_easy_perform(void *curl);
    void curl_easy_cleanup(void *curl);
    char *curl_easy_strerror(int code);
    struct _iobuf {
        char *_ptr;
        int   _cnt;
        char *_base;
        int   _flag;
        int   _file;
        int   _charbuf;
        int   _bufsiz;
        char *_tmpfname;
        };
	typedef struct _iobuf FILE;
]]
local libcurl = ffi.load('libcurl')
local curl= 0
HTTP={
	CURLOPT_URL = 10002,
	CURLOPT_WRITEFUNCTION = 20011,
	CURLOPT_VERBOSE = 41,
	CURLOPT_PROGRESSDATA = 10057,
	CURLOPT_NOPROGRESS = 43,
	CURLOPT_WRITEDATA = 10001,
	CURLE_OK = 0,
	CURLOPT_TIMEOUT =13,
	CURLOPT_PROGRESSFUNCTION=20056,


	time_out=60
}


HTTP.Init=function()
	if HTTP.has_init== nil then
		curl = libcurl.curl_easy_init()
		HTTP.has_init= true
	end
end

HTTP.Clear=function()
	if HTTP.has_init ~= nil then
		libcurl.curl_easy_cleanup(curl)
		curl = nil
		HTTP.has_init= nil
	end
end

HTTP.DownLoadFile=function (filename,url,process_callback)
	HTTP.Init()

	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_URL, url)
	local file=io.open(filename,"wb")
	local f=ffi.cast("FILE *",file)
	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_WRITEDATA,f )
	local cb = ffi.cast("curl_progress_callback", function (clientp,dltotal,dlnow,ultotal,ulnow)
		process_callback(clientp,dltotal,dlnow,ultotal,ulnow)
		return 0
	end)
	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_NOPROGRESS, false);
	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_PROGRESSFUNCTION, cb);
	local resualt = libcurl.curl_easy_perform(curl)

	HTTP.Clear()

	return resualt
end

HTTP.Visit=function (url)
	HTTP.Init()
	local res=[[]]
	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_URL, url)
	local cb = ffi.cast("curl_write_callback", function(ptr, size, nmemb, userdata)
		res=res..ffi.string(ptr)
		--print(ffi.string(ptr),size,nmemb,userdata)
		return size
	end)
	libcurl.curl_easy_setopt(curl, HTTP.CURLOPT_WRITEFUNCTION, cb);
	local resualt = libcurl.curl_easy_perform(curl)
	HTTP.Clear()
	return res
end