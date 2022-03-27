# luaenv-luarocks

This plugin provides a hook for [luaenv](https://github.com/cehoffman/luaenv)
that ensures [LuaRocks](https://github.com/luarocks/luarocks) is installed after Lua.

## Installation

With git:

```sh
git clone https://github.com/jmcantrell/luaenv-luarocks.git "$(luaenv root)"/plugins/luaenv-luarocks
```

## Usage

By default, `luaenv install VERSION` will include the latest version
of LuaRocks. If you need a different version, specify it like so:

```sh
LUAENV_LUAROCKS_VERSION=3.8.0 luaenv install 5.4.4
```
