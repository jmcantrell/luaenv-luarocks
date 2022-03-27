luarocks_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/luaenv-luarocks

get_luarocks_versions() {
    curl -s "https://api.github.com/repos/luarocks/luarocks/tags" |
        jq -r '.[] | .name' | grep -E '^v[0-9.]+$' | sed 's/^v//' |
        sort --version-sort
}

validate_luarocks_version() {
    if [[ ! -v 1 || $1 == latest ]]; then
        get_luarocks_versions | tail -n1
    else
        get_luarocks_versions | grep -q "^${1##v}$"
    fi
}

install_luarocks() {
    # Only install default rocks after successfully installing Lua.
    [[ $STATUS == 0 ]] || return 0

    local version
    version=$(validate_luarocks_version "${LUAENV_LUAROCKS_VERSION:-latest}") || return 1

    local package=$luarocks_cache_dir/v${version}.tar.gz

    if [[ ! -f $package ]]; then
        echo "Downloading LuaRocks v${version} package..."
        mkdir -p "$luarocks_cache_dir" || return 1
        curl -sSL --output-dir "$luarocks_cache_dir" --remote-name \
            "https://github.com/luarocks/luarocks/archive/refs/tags/${package##*/}" || return 1
    fi

    echo "Extracting LuaRocks v${version} package..."
    tar -C "$luarocks_cache_dir" -x -f "$package" || return 1

    pushd "$luarocks_cache_dir/luarocks-$version" >/dev/null || return 1

    local lua_prefix=$LUAENV_ROOT/versions/$VERSION_NAME

    ./configure \
        --prefix="$lua_prefix" \
        --with-lua-bin="$lua_prefix"/bin \
        --with-lua-include="$lua_prefix"/include \
        --force-config || return 1

    make bootstrap || return 1

    popd >/dev/null || return 1
}

install_default_rocks() {
    local default_rocks=${LUAENV_LUAROCKS_DEFAULT_ROCKS:-$LUAENV_ROOT/default-rocks}

    # If there's no package list, no need to continue.
    [[ -f $default_rocks ]] || return 0

    local args
    while IFS=" " read -ra args; do
        # Skip empty lines.
        ((${#args[@]} == 0)) && continue

        # Skip comment lines that begin with `#`.
        [[ ${args[0]:0:1} == "#" ]] && continue

        # Invoke `luarocks install` in the just-installed Lua.
        # Point its stdin to /dev/null or else it'll read from our default-rocks file.
        if ! LUAENV_VERSION=$VERSION_NAME luaenv-exec luarocks install "${args[@]}" </dev/null; then
            echo "luaenv: error installing rock \`${args[0]}'" >&2
            return 1
        fi
    done <"$default_rocks"
}

if declare -Ff after_install >/dev/null; then
    after_install install_luarocks
    after_install install_default_rocks
else
    echo "luaenv: luaenv-luarocks plugin requires a lua-build version with the after_install hook" >&2
fi
