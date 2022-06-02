class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.10.tar.bz2"
  sha256 "9c70b3fbbb0c5c7bf761ef66c3d5b939ab45ad063e055990f17f40f1f6f96572"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sord"
    sha256 cellar: :any, mojave: "0c5496b0922b73414f5d049fb17c8139e350340d8a3766fad4da38da71c33e38"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
