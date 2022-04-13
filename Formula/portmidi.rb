class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://github.com/PortMidi/portmidi"
  url "https://github.com/PortMidi/portmidi/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/portmidi"
    sha256 cellar: :any, mojave: "58b2a688a4db8ea924e085a83bbb03a0019ec6db9c6c3a4a397f580a30d2f3ca"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    if OS.mac?
      # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
      # "error: expected function body after function declarator" on 10.12
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
      mv lib/shared_library("libportmidi"), lib/shared_library("libportmidi", version)
    else
      system "cmake", ".", *std_cmake_args, "-DCMAKE_CACHEFILE_DIR=#{buildpath}/build"
      system "make", "install"
      lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", 0)
    end
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi")
    lib.install_symlink shared_library("libportmidi", version) => shared_library("libportmidi", version.major.to_s)
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
