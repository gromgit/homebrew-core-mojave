require "language/perl"

class Ipv6calc < Formula
  include Language::Perl::Shebang

  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/4.0.2.tar.gz"
  sha256 "f96a89bdce201ec313f66514ee52eeab5f5ead3d2ba9efe5ed9f757632cd01a1"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipv6calc"
    sha256 cellar: :any_skip_relocation, mojave: "8dae946d09becac0d804ba03a78c6c640ad9c0821e48ac283893b86de25703c5"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.17.tar.gz"
      sha256 "5f7e42b769cb27499113cfae4b786c37d49e7c7d32dbb469602cd808308568f8"
    end

    resource "HTML::Entities" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.80.tar.gz"
      sha256 "63411db03016747e37c2636db11b05f8cc71608ef5bff36d04ddb0dc92f7835b"
    end

    resource "DIGEST::Sha1" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz"
      sha256 "68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "install"
        end
      end

      rewrite_shebang detected_perl_shebang, "ipv6calcweb/ipv6calcweb.cgi.in"

      # ipv6calcweb.cgi is a CGI script so it does not use PERL5LIB
      # Add the lib path at the top of the file
      inreplace "ipv6calcweb/ipv6calcweb.cgi.in",
                "use URI::Escape;",
                "use lib \"#{libexec}/lib/perl5/\";\nuse URI::Escape;"
    end

    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
