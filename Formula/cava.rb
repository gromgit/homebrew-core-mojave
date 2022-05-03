class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.8.2.tar.gz"
  sha256 "99bc302ce77f8093a4ac1cf94be51581e37c075428117f248ffe1fee650f47d8"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cava"
    sha256 cellar: :any, mojave: "867b4fa25e8c76bec76a3d1a6f24db4675726b684b1e7494d8b24b3498bc551c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cava_config = (testpath/"cava.conf")
    cava_stdout = (testpath/"cava_stdout.log")

    (cava_config).write <<~EOS
      [general]
      bars = 2
      sleep_timer = 1

      [input]
      method = fifo
      source = /dev/zero

      [output]
      method = raw
      data_format = ascii
    EOS

    pid = spawn(bin/"cava", "-p", cava_config, [:out, :err] => cava_stdout.to_s)
    sleep 2
    Process.kill "KILL", pid
    assert_match "0;0;\n", cava_stdout.read
  end
end
