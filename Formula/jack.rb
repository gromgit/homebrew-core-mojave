class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.21.tar.gz"
  sha256 "8b044a40ba5393b47605a920ba30744fdf8bf77d210eca90d39c8637fe6bc65d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jack"
    sha256 mojave: "edb0cba781e856d0b953ad24d92a68f18cc02293d3af3a5c1a80d86fa8a10f8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "berkeley-db"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "readline"

  on_macos do
    depends_on "aften"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    if OS.mac? && MacOS.version <= :high_sierra
      # See https://github.com/jackaudio/jack2/issues/640#issuecomment-723022578
      ENV.append "LDFLAGS", "-Wl,-compatibility_version,1"
      ENV.append "LDFLAGS", "-Wl,-current_version,#{version}"
    end
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}", "--example-tools"
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "install"
  end

  service do
    run [opt_bin/"jackd", "-X", "coremidi", "-d", "coreaudio"]
    keep_alive true
    working_dir opt_prefix
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin"
  end

  test do
    source_name = "test_source"
    sink_name = "test_sink"
    fork do
      if OS.mac?
        exec "#{bin}/jackd", "-X", "coremidi", "-d", "dummy"
      else
        exec "#{bin}/jackd", "-d", "dummy"
      end
    end
    system "#{bin}/jack_wait", "--wait", "--timeout", "10"
    fork do
      exec "#{bin}/jack_midiseq", source_name, "16000", "0", "60", "8000"
    end
    midi_sink = IO.popen "#{bin}/jack_midi_dump #{sink_name}"
    sleep 1
    system "#{bin}/jack_connect", "#{source_name}:out", "#{sink_name}:input"
    sleep 1
    Process.kill "TERM", midi_sink.pid

    midi_dump = midi_sink.read
    assert_match "90 3c 40", midi_dump
    assert_match "80 3c 40", midi_dump
  end
end
