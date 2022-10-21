class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.11.0.tar.gz"
  sha256 "437d45e0e35c18cf3e59bcfe5dfe37566547eb121e69fca64b98f5d2c1c2d424"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rabbitmq-c"
    rebuild 2
    sha256 cellar: :any, mojave: "cfb81e1d92a8097ec15a72587fb86ce174daa2e535189c716bbb031d71872890"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"
  depends_on "popt"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_API_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_TOOLS=ON",
                    "-DBUILD_TOOLS_DOCS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
