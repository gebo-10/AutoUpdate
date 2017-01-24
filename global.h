#include <stdio.h>
extern "C"
{
	#include "lua.h"
	#include "lualib.h"
	#include "luajit.h"
	#include "lauxlib.h"
}

#include "curl.h"
#include "luaEng.h"
int update(void);