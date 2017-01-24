#ifndef LUAENG
#define LUAENG
#include <stdio.h>
#include "util.h"
extern "C"
{
	#include "lua.h"
	#include "lualib.h"
	#include "luajit.h"
	#include "lauxlib.h"
}
class LuaEng{
private:
	lua_State *L;
public:
	LuaEng(){
		L = luaL_newstate();
		luaL_openlibs(L);
	}
	void dofile(char * file){
		luaL_dofile(L, file);
	}
	int exeFun(char* functionName)
	{
		lua_getglobal(L, functionName);
		if (!lua_isfunction(L, -1))
		{
			log("is not lua function");
			lua_pop(L, 1);
			return 0;
		}

		int error = lua_pcall(L, 0, 0, 0);           
		logError(error);
		return 1;
	}

	void logError(int sErr)
	{
		if (sErr == 0)
		{
			return;
		}
		const char* error;
		char sErrorType[256] = { 0 };
		switch (sErr)
		{
		case LUA_ERRSYNTAX://编译时错误
			/*const char *buf = "mylib.myfun()2222";类似这行语句可以引起编译时错误*/
			sprintf_s(sErrorType, sizeof(sErrorType), "%s", "syntax error during pre-compilation");
			break;
		case LUA_ERRMEM://内存错误
			sprintf_s(sErrorType, sizeof(sErrorType), "%s", "memory allocation error");
			break;
		case LUA_ERRRUN://运行时错误
			/*const char *buf = "my222lib.myfun()";类似这行语句可以引起运行时错误，my222lib实际上不存在这样的库，返回的值是nil*/
			sprintf_s(sErrorType, sizeof(sErrorType), "%s", "a runtime error\n");
			//printf("[LUA ERROR] %s", lua_tostring(L, -1));
			//lua_pop(L, 1); // clean error message
			break;
		case LUA_YIELD://线程被挂起错误
			sprintf_s(sErrorType, sizeof(sErrorType), "%s", "Thread has Suspended");
			break;
		case LUA_ERRERR://在进行错误处理时发生错误
			sprintf_s(sErrorType, sizeof(sErrorType), "%s", "error while running the error handler function");
			break;
		default:
			break;
		}
		error = lua_tostring(L, -1);//打印错误结果
		printf("%s:%s", sErrorType, error);
		lua_pop(L, 1);
		getchar();
	}

};

#endif