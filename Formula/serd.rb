class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.10.tar.bz2"
  sha256 "affa80deec78921f86335e6fc3f18b80aefecf424f6a5755e9f2fa0eb0710edf"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serd"
    rebuild 1
    sha256 cellar: :any, mojave: "0c77fd1546c6624fe9937fb105025be8884843026dac5c618b62152b93f23b5d"
  end

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "python@3.10" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" if OS.linux?
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    pipe_output("serdi -", "() a <http://example.org/List> .", 0)
  end
end
