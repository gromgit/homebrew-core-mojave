class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://osm2pgsql.org"
  url "https://github.com/openstreetmap/osm2pgsql/archive/1.6.0.tar.gz"
  sha256 "0ec8b58ab972ac8356185af4161270c1b625a77299f09e5fb7f45e616ef1a9a5"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/openstreetmap/osm2pgsql.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/osm2pgsql"
    sha256 mojave: "f63e05231469a1c551d336007806f2733c7e14402953428c9b5655666bc4ba80"
  end

  depends_on "cmake" => :build
  depends_on "lua" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "luajit-openresty"
  depends_on "postgresql"
  depends_on "proj"

  def install
    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", /set\(LUA_VERSIONS5( \d\.\d)+\)/,
                                     "set(LUA_VERSIONS5 #{lua_version})"

    mkdir "build" do
      system "cmake", "-DWITH_LUAJIT=ON", "-DUSE_PROJ_LIB=6", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Connecting to database failed: connection to server",
                 shell_output("#{bin}/osm2pgsql /dev/null 2>&1", 1)
  end
end
