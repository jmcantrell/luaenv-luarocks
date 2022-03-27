# luaenv-luarocks

This plugin provides a hook for [luaenv](https://github.com/cehoffman/luaenv)
that ensures [LuaRocks](https://github.com/luarocks/luarocks) is installed after Lua.

## Dependencies

Beyond the basic requirements of luaenv, `curl` and `jq` are required
to fetch and parse JSON data from GitHub.

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

### Default Rocks

Rocks that are installed by default can be specified in the file
defined by `LUAENV_LUAROCKS_DEFAULT_ROCKS` (which defaults to
`$(luaenv root)/default-rocks`). If this file exists, it should be a
list of package names, one per line. You may optionally specify a
version string after the name. For example:

    luasocket
    lake 1.4.1

Blank lines and lines beginning with a `#` are ignored.
