class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://github.com/Sude-/lgogdownloader/releases/download/v3.9/lgogdownloader-3.9.tar.gz"
  sha256 "d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0"
  license "WTFPL"
  revision 1
  head "https://github.com/Sude-/lgogdownloader.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lgogdownloader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lgogdownloader"
    sha256 cellar: :any, mojave: "af368668c2bb9c645436efd3ed989b83cfe7a34ea9d85e6341bad47299d5e89d"
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DJSONCPP_INCLUDE_DIR=#{Formula["jsoncpp"].opt_include}"

    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    lastline = ""
    begin
      reader.each_line { |line| lastline = line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_equal "HTTP: Login failed", lastline.chomp
    reader.close
  end
end
