class SpeechTools < Formula
  desc "C++ speech software library from the University of Edinburgh"
  homepage "http://festvox.org/docs/speech_tools-2.4.0/"
  revision 2
  head "https://github.com/festvox/speech_tools.git", branch: "master"

  stable do
    url "http://festvox.org/packed/festival/2.5/speech_tools-2.5.0-release.tar.gz"
    sha256 "e4fd97ed78f14464358d09f36dfe91bc1721b7c0fa6503e04364fb5847805dcc"

    # Fix build on Apple Silicon. Remove in the next release.
    patch do
      url "https://github.com/festvox/speech_tools/commit/06141f69d21bf507a9becb5405265dc362edb0df.patch?full_index=1"
      sha256 "a42493982af11a914d2cf8b97edd287a54b5cabffe6c8fe0e4a9076c211e85ef"
    end
  end

  livecheck do
    url "http://festvox.org/packed/festival/?C=M&O=D"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/speech-tools"
    sha256 cellar: :any, mojave: "8c7ed8c33df4a29bcc6a62986706863b730ba8701cd98f7f8b21b4b6592cea49"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "align", because: "both install `align` binaries"

  def install
    ENV.deparallelize
    # Xcode doesn't include OpenMP directly any more, but with these
    # flags we can force the compiler to use the libomp we provided
    # as a dependency.  Normally you can force this on autoconf by
    # setting "ac_cv_prog_cxx_openmp" and "LIBS", but this configure
    # script does OpenMP its own way so we need to actually edit the script:
    inreplace "configure", "-fopenmp", "-Xpreprocessor -fopenmp -lomp" if OS.mac?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # install all executable files in "main" directory
    bin.install Dir["main/*"].select { |f| File.file?(f) && File.executable?(f) }
  end

  test do
    rate_hz = 16000
    frequency_hz = 100
    duration_secs = 5
    basename = "sine"
    txtfile = "#{basename}.txt"
    wavfile = "#{basename}.wav"
    ptcfile = "#{basename}.ptc"

    File.open(txtfile, "w") do |f|
      scale = (2 ** 15) - 1
      samples = Array.new(duration_secs * rate_hz) do |i|
        (scale * Math.sin(frequency_hz * 2 * Math::PI * i / rate_hz)).to_i
      end
      f.puts samples
    end

    # convert to wav format using ch_wave
    system bin/"ch_wave", txtfile,
      "-itype", "raw",
      "-istype", "ascii",
      "-f", rate_hz.to_s,
      "-o", wavfile,
      "-otype", "riff"

    # pitch tracking to est format using pda
    system bin/"pda", wavfile,
      "-shift", (1 / frequency_hz.to_f).to_s,
      "-o", ptcfile,
      "-otype", "est"

    # extract one frame from the middle using ch_track, capturing stdout
    value = frequency_hz * duration_secs / 2
    pitch = shell_output("#{bin}/ch_track #{ptcfile} -from #{value} -to #{value}")

    # should be 100 (Hz)
    assert_equal frequency_hz, pitch.to_i
  end
end
