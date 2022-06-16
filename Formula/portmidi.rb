class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  revision 1
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/portmidi"
    sha256 cellar: :any, mojave: "f86f306df7b544be696cf81415ca0e926054ebd303f3404067a7fe2b0bc3168a"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    if OS.mac? && MacOS.version <= :sierra
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is
      # installed
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <portmidi.h>

      int main()
      {
        int count = -1;
        count = Pm_CountDevices();
        if(count >= 0)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lportmidi", "-o", "test"
    system "./test"
  end
end
