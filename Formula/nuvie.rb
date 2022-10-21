class Nuvie < Formula
  desc "Ultima 6 engine"
  homepage "https://nuvie.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nuvie/Nuvie/0.5/nuvie-0.5.tgz"
  sha256 "ff026f6d569d006d9fe954f44fdf0c2276dbf129b0fc5c0d4ef8dce01f0fc257"
  license "GPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nuvie"
    sha256 cellar: :any, mojave: "aa7ad87e08042ba7f26fdd925fe340e7c4b115e2afc972a500304c66b9e88aae"
  end

  head do
    url "https://github.com/nuvie/nuvie.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "sdl12-compat"

  def install
    # Work around GCC 11 failure due to default C++17 standard.
    # We use C++03 standard as C++11 standard needs upstream fix.
    # Ref: https://github.com/nuvie/nuvie/commit/69fb52d35d5eaffcf3bca56929ab58a99defec3d
    ENV.append "CXXFLAGS", "-std=c++03" if OS.linux?

    inreplace "./nuvie.cpp" do |s|
      s.gsub! 'datadir", "./data"',
              "datadir\", \"#{lib}/data\""
      s.gsub! 'home + "/Library',
              '"/Library'
      s.gsub! 'config_path.append("/Library/Preferences/Nuvie Preferences");',
              "config_path = \"#{var}/nuvie/nuvie.cfg\";"
      s.gsub! "/Library/Application Support/Nuvie Support/",
              "#{var}/nuvie/game/"
      s.gsub! "/Library/Application Support/Nuvie/",
              "#{var}/nuvie/"
    end
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-sdltest"
    system "make"
    bin.install "nuvie"
    pkgshare.install "data"
  end

  def post_install
    (var/"nuvie/game").mkpath
  end

  def caveats
    <<~EOS
      Copy your Ultima 6 game files into the following directory:
        #{var}/nuvie/game/ultima6/
      Save games will be stored in the following directory:
        #{var}/nuvie/savegames/
      Config file will be located at:
        #{var}/nuvie/nuvie.cfg
    EOS
  end

  test do
    pid = fork do
      exec bin/"nuvie"
    end
    sleep 3

    assert_predicate bin/"nuvie", :exist?
    assert_predicate bin/"nuvie", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
