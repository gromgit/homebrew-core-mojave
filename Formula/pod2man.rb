class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-5.00.tar.xz"
  sha256 "e0988b10795c75c50e5d04eba928b5500cf979e231f2c80d21ddf5f9d4c491ba"

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pod2man"
    sha256 cellar: :any_skip_relocation, mojave: "84700f3e53d45625289d2f4becbbd051609821068487e552591910282cf2288a"
  end

  keg_only "perl ships with pod2man"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.43.tar.gz"
    sha256 "65abe3f5363fa4cdc108f5ad9ce5ce91e7a39186a1b297bb7a06fa1b0f45d377"
  end

  def install
    resource("Pod::Simple").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end
    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                   "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: "#{lib}/perl5:#{libexec}/lib/perl5"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
    assert_match "Pod::Man #{version}", manpage
  end
end
