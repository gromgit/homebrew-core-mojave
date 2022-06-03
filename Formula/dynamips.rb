class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.22.tar.gz"
  sha256 "5b3142eb4d2780683ea8781d5f4da6fc39c514d36546392508c74da8ba98240b"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dynamips"
    sha256 cellar: :any_skip_relocation, mojave: "88d2dedfe7f408ca161f81eb2ecaaf9d28f9a136e7bf44cbec1c784278871bbd"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    cmake_args = std_cmake_args + ["-DANY_COMPILER=1"]
    cmake_args << if OS.mac?
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{Formula["elfutils"].opt_include}"
    end

    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
