class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.7.5.tar.gz"
  sha256 "e9807568c2c5a10240c635e1e9ad5dbe63326eb730ca3aac005e19d91d2cd1c5"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fastfetch"
    sha256 mojave: "5fed52acf846ec327b437ea7b5a398cf3ede2d8bcc49a9bb7378b3ab81977baa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
