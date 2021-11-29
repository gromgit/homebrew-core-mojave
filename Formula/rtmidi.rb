class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-5.0.0.tar.gz"
  sha256 "c0f57eca5e7ebc8773375d5e9f56405d2b37a255a509fa57d2dc4f7e87d2c564"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtmidi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rtmidi"
    rebuild 1
    sha256 cellar: :any, mojave: "8d0abf4c3f7da6a655ef4f6aa6f78931a555d868254a2914e2825c83d60e8d10"
  end

  head do
    url "https://github.com/thestk/rtmidi.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "RtMidi.h"
      int main(int argc, char **argv, char **env) {
        RtMidiIn midiin;
        RtMidiOut midiout;
        std::cout << "Input ports: " << midiin.getPortCount() << "\\n"
                  << "Output ports: " << midiout.getPortCount() << "\\n";
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/rtmidi", "-L#{lib}", "-lrtmidi"
    # Only run the test on macOS since ALSA initialization errors on Linux CI.
    # ALSA lib seq_hw.c:466:(snd_seq_hw_open) open /dev/snd/seq failed: No such file or directory
    system "./test" if OS.mac?
  end
end
