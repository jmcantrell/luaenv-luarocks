# luaenv-luarocks

This is a plugin for [luaenv](https://github.com/cehoffman/luaenv)
that lets you manage versions of
[LuaRocks](https://github.com/luarocks/luarocks).

## Installation

With git:
```sh
git clone https://github.com/jmcantrell/luaenv-luarocks.git "$(luaenv root)"/plugins/luaenv-luarocks
```

## Usage

List all available LuaRocks versions:

```sh
luaenv luarocks list
```

Install the latest version of LuaRocks in the version of lua used by luaenv:
```sh
luaenv luarocks install
```

Install a specific version:
```sh
luaenv luarocks install 3.8.0
```

Uninstall the latest version:
```sh
luaenv luarocks uninstall
```

Uninstall a specific version:
```sh
luaenv luarocks uninstall 3.8.0
```
