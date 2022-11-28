class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.1.0.tar.gz"
  sha256 "fe6d21741ec7f3fc9df409d921f47dfc73a4d8ff64f4ac6f1d95f951bf7f53d6"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hiredis"
    sha256 cellar: :any, mojave: "77b143f247b480ffb82af067640291dd2f66d0a174505190bf89d6611b600590"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_predicate testpath/"test", :exist?
  end
end
