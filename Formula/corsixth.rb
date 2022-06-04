class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://github.com/CorsixTH/CorsixTH/archive/v0.65.1.tar.gz"
  sha256 "b8a1503371fa0c0f3d07d3b39a3de2769b8ed25923d0d931b7075bc88e3f508f"
  license "MIT"
  revision 1
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/corsixth"
    rebuild 1
    sha256 mojave: "5ca649899d8f1a0b0e124909ee1ee5021f04ba225146d869337e49d86d046b3f"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on xcode: :build
  depends_on "ffmpeg@4"
  depends_on "freetype"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
    mirror "https://sources.voidlinux.org/lua-lpeg-1.0.2/lpeg-1.0.2.tar.gz"
    sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = luapath/"share/lua"/lua.version.major_minor/"?.lua"
    ENV["LUA_CPATH"] = luapath/"lib/lua"/lua.version.major_minor/"?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

    datadir = OS.mac? ? prefix/"CorsixTH.app/Contents/Resources/" : pkgshare
    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DLUA_PROGRAM_PATH=#{lua.opt_bin}/lua
      -DCORSIX_TH_DATADIR=#{datadir}
    ]
    # On Linux, install binary to libexec/bin so we can put an env script with LUA_PATH in bin.
    args << "-DCMAKE_INSTALL_BINDIR=#{libexec}/bin" unless OS.mac?

    system "cmake", ".", *args
    system "make"
    if OS.mac?
      resources = %w[
        CorsixTH/CorsixTH.lua
        CorsixTH/Lua
        CorsixTH/Levels
        CorsixTH/Campaigns
        CorsixTH/Graphics
        CorsixTH/Bitmap
      ]
      cp_r resources, "CorsixTH/CorsixTH.app/Contents/Resources/"
      prefix.install "CorsixTH/CorsixTH.app"
    else
      system "make", "install"
    end

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin_path = OS.mac? ? prefix/"CorsixTH.app/Contents/MacOS/CorsixTH" : libexec/"bin/corsix-th"
    (bin/"CorsixTH").write_env_script(bin_path, lua_env)
  end

  test do
    if OS.mac?
      lua = Formula["lua"]

      app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
      assert_includes MachO::Tools.dylibs(app), "#{lua.opt_lib}/liblua.dylib"
    end

    PTY.spawn(bin/"CorsixTH") do |r, _w, pid|
      sleep 30
      Process.kill "KILL", pid

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end

      assert_match "Welcome to CorsixTH", output
    end
  end
end
