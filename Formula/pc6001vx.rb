class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.8.2_src.tar.gz"
  sha256 "7abe9b10aa6f683eda279794bc03ee05e1b0b2239e38718860333d35f91b4858"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pc6001vx"
    sha256 cellar: :any, mojave: "7cadd8244875afd7d28f8743d8d8e22c1d37fe29ad1e180bd59b60746c62b969"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "qt@5"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["ffmpeg@4"].opt_include}"

    mkdir "build" do
      qt5 = Formula["qt@5"].opt_prefix
      system "#{qt5}/bin/qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      if OS.mac?
        prefix.install "PC6001VX.app"
        bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
      else
        bin.install "PC6001VX"
      end
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    user_config_dir = testpath/".pc6001vx"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 15
    assert_predicate user_config_dir/"pc6001vx.ini",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
