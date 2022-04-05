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
    rebuild 2
    sha256 cellar: :any, mojave: "881c5e219840cb95822ce2b6c052032d5c077da9af6968e0d399cf6f782626fe"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("serdi -", "() a <http://example.org/List> .")
  end
end
