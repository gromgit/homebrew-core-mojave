class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v1.0.3.tar.gz"
  sha256 "ee444518353833b2b8f1b106bb4d9e9c15ae4d48569be9b6c89fc38dabf364b7"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fdk-aac-encoder"
    sha256 cellar: :any, mojave: "1dd26d4031c60fb7b060d3bc70fc6581bbf26e4ee697722c496c5f495b8cb0ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fdk-aac"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # generate test tone pcm file
    sample_rate = 44100
    two_pi = 2 * Math::PI

    num_samples = sample_rate
    frequency = 440.0
    max_amplitude = 0.2

    position_in_period = 0.0
    position_in_period_delta = frequency / sample_rate

    samples = [].fill(0.0, 0, num_samples)

    num_samples.times do |i|
      samples[i] = Math.sin(position_in_period * two_pi) * max_amplitude

      position_in_period += position_in_period_delta

      position_in_period -= 1.0 if position_in_period >= 1.0
    end

    samples.map! do |sample|
      (sample * 32767.0).round
    end

    File.open("#{testpath}/tone.pcm", "wb") do |f|
      f.syswrite(samples.flatten.pack("s*"))
    end

    system "#{bin}/fdkaac", "-R", "--raw-channels", "1", "-m",
           "1", "#{testpath}/tone.pcm", "--title", "Test Tone"
  end
end
