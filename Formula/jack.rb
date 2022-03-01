class Jack < Formula
  desc "Audio Connection Kit"
  homepage "https://jackaudio.org/"
  url "https://github.com/jackaudio/jack2/archive/v1.9.19.tar.gz"
  sha256 "9030f4dc11773351b6ac96affd9c89803a5587ebc1b091e5ff866f433327e4b0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jack"
    sha256 mojave: "6b5cfab3c411d7e426cd00762ca9f07c559a3f7064515bb6a2c2ded3dfd0a3af"
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
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}"
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.10"].opt_bin/"python3", "./waf", "install"

    # Remove Python script used to control D-Bus JACK as it isn't enabled in formula
    rm bin/"jack_control"
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
