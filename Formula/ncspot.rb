class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.10.1.tar.gz"
  sha256 "7c2ed75bcf75d3da751bf6193b3a70266f41b953e840042b3a294f221a2d59a3"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ncspot"
    sha256 cellar: :any, mojave: "0fa79c70a4368e38d21cc45b8493233645d8c2142d237ccf23a9cc68a31ab2c9"
  end

  depends_on "python@3.10" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend,share_clipboard",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
