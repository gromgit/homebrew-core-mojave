class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/v1.14.tar.gz"
  sha256 "e063de9efa5635260c8def00a4d41ec6145226a492d53fa1dac436967670d195"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/darkhttpd"
    sha256 cellar: :any_skip_relocation, mojave: "9dfb91c9ff3141e2c57c924081e3d2d6c34976ef25fb2a61301ec07127d73e4c"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
