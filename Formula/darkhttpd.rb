class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/v1.13.tar.gz"
  sha256 "1d88c395ac79ca9365aa5af71afe4ad136a4ed45099ca398168d4a2014dc0fc2"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/darkhttpd"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f417a0bf3183bc06b0e98a66b069937b9b70ac6cc9a99ebced2f1c8ebdaad761"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
