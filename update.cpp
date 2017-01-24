#include "global.h"

size_t write_data(char *buffer, size_t size, size_t nitems, void *outstream)
{
	int written = fwrite(buffer, size, nitems, (FILE*)outstream);
	return written;
}

int getProgressValue(const char* flag, double dt, double dn, double ult, double uln){
	printf("%lf\n",dn);
	return 0;
}
int downloadFile(char * filename, char * url){
	CURL* pCurl = curl_easy_init();

	FILE* pFile = fopen(filename, "wb");

	curl_easy_setopt(pCurl, CURLOPT_WRITEDATA, (void*)pFile);

	curl_easy_setopt(pCurl, CURLOPT_WRITEFUNCTION, write_data);
	
	curl_easy_setopt(pCurl, CURLOPT_NOPROGRESS, false);
	curl_easy_setopt(pCurl, CURLOPT_PROGRESSFUNCTION, getProgressValue);  //设置回调的进度函数
	curl_easy_setopt(pCurl, CURLOPT_URL, url);

	curl_easy_perform(pCurl);

	fclose(pFile);

	curl_easy_cleanup(pCurl);
	return 0;
}

int update(){
	LuaEng luaEng;
	luaEng.dofile("update.lua");
	luaEng.exeFun("start");
	//downloadFile("a.zip","127.0.0.1/lua.zip");
	printf("update end");
	return 1;
}

extern "C"   
{  
    __declspec(dllexport) void __cdecl df(int pre,...)  
    {  
    	va_list arg_ptr;
    	va_start(arg_ptr,pre);
    	void * a=va_arg(arg_ptr,void *);

    	downloadFile("c_df.zip","localhost/lua.zip");
    	((void (*)(int))a)(333);
    }  
    __declspec(dllexport) int  Add(int a,int b)  
    {  
        return a+b;  
    }  
} 