class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.16.tar.xz"
  sha256 "f50f486da519cdd8d03b20c9e42414e459133f5a244411d8e63caef8d9ac9146"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serd"
    sha256 cellar: :any, mojave: "63a8f63f66a6c0f3af0fea1737e94f615f4fdc8c9c49d228a6360ea6b571d49a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("serdi -", "() a <http://example.org/List> .")
  end
end
