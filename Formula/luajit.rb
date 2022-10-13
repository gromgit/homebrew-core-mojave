# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
# TODO: Add an audit in `brew` for this. https://github.com/Homebrew/homebrew-core/pull/104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  # Get the latest commit with:
  #   `git ls-remote --heads https://github.com/LuaJIT/LuaJIT.git v2.1`
  url "https://github.com/LuaJIT/LuaJIT/archive/6c4826f12c4d33b8b978004bc681eb1eef2be977.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.0-beta3-20221004.1"
  sha256 "19a911fdd77af69e48fa50749606a9009696f543cc88e898b4480d8d3c8828f5"
  license "MIT"
  head "https://luajit.org/git/luajit-2.0.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      newest_date = nil
      commit_count = 0
      page.scan(regex).map do |match|
        date = Date.parse(match[0])
        newest_date ||= date
        break if date != newest_date

        commit_count += 1
      end
      next if newest_date.blank? || commit_count.zero?

      # The main LuaJIT version is rarely updated, so we recycle it from the
      # `version` to avoid having to fetch another page.
      version.to_s.sub(/\d+\.\d+$/, "#{newest_date.strftime("%Y%m%d")}.#{commit_count}")
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/luajit"
    sha256 cellar: :any, mojave: "9db323b0e982b42723f51696149c5f9971d6c2a5fa32132eb275df58ac2e4108"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath/"doc").children

    # We need `stable.version` here to avoid breaking symlink generation for HEAD.
    upstream_version = stable.version.to_s.sub(/-\d+\.\d+$/, "")
    # v2.1 branch doesn't install symlink for luajit.
    # This breaks tools like `luarocks` that require the `luajit` bin to be present.
    bin.install_symlink "luajit-#{upstream_version}" => "luajit"

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/shared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end
  end

  test do
    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin/"luajit", "-b", "-o", "osx", "-a", "arm64", "empty.lua", "empty.o"
    assert_predicate testpath/"empty.o", :exist?

    # Check that we're not affected by https://github.com/LuaJIT/LuaJIT/issues/865.
    require "macho"
    machobj = MachO.open("empty.o")
    assert_kind_of MachO::FatFile, machobj
    assert_predicate machobj, :object?

    cputypes = machobj.machos.map(&:cputype)
    assert_includes cputypes, :arm64
    assert_includes cputypes, :x86_64
    assert_equal 2, cputypes.length
  end
end
