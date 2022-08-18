class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "https://github.com/coccinelle/coccinelle.git",
      tag:      "1.1.1",
      revision: "5444e14106ff17404e63d7824b9eba3c0e7139ba"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/coccinelle"
    sha256 mojave: "72f49bb656145ea5d96bbd88b312264fefe655dad595ff97a6b5fe6292edf667"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hevea" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "ocaml"
  depends_on "pcre"

  uses_from_macos "unzip" => :build

  # Bootstap resource for Ocaml 4.12 compatibility.
  # Remove when Coccinelle supports Ocaml 4.12 natively
  resource "stdcompat" do
    url "https://github.com/thierry-martinez/stdcompat/releases/download/v15/stdcompat-15.tar.gz"
    sha256 "5e746f68ffe451e7dabe9d961efeef36516b451f35a96e174b8f929a44599cf5"
  end

  def install
    resource("stdcompat").stage do
      system "./configure", "--prefix=#{buildpath}/bootstrap"
      ENV.deparallelize { system "make" }
      system "make", "install"
    end
    ENV.prepend_path "OCAMLPATH", buildpath/"bootstrap/lib"

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "./autogen"
      system "opam", "config", "exec", "--", "./configure",
                            "--disable-dependency-tracking",
                            "--enable-release",
                            "--enable-ocaml",
                            "--enable-opt",
                            "--with-pdflatex=no",
                            "--prefix=#{prefix}",
                            "--libdir=#{lib}"
      ENV.deparallelize
      system "opam", "config", "exec", "--", "make"
      system "make", "install"
    end

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system "#{bin}/spatch", "-sp_file", "#{pkgshare}/simple.cocci",
                            "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS
    assert_equal expected, (testpath/"new_simple.c").read
  end
end
