class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/osm2pgsql"
    sha256 mojave: "eca83e544944a31c7adb2d9b3ec05ce4a95688e70114d7f4b0193ed50a169fe9"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj@7"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    # Use Proj 6.0.0 compatibility headers
    # https://github.com/openstreetmap/osm2pgsql/issues/922
    # and https://github.com/osmcode/libosmium/issues/277
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
