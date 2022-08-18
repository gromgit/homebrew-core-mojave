class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  # Don't use git tags, their naming is misleading
  url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7046.tar.gz"
  sha256 "3e8c9d9b44a7348f9acc917163dbfc15bd5ea72501492cea3a35b346440ff862"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  version_scheme 1

  head "https://github.com/miyagawa/cpanminus.git", branch: "devel"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpanminus"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "067306cccbe430d43e910a5ee4d2d945bec0ef0a6fd49ba4a1a900f069bf207b"
  end

  uses_from_macos "perl"

  def install
    cd "App-cpanminus" if build.head?

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"
  end

  def post_install
    cpanm_lines = (bin/"cpanm").read.lines
    return if cpanm_lines.first.match?(%r{^#!/usr/bin/env perl})

    ohai "Adding `/usr/bin/env perl` shebang to `cpanm`..."
    cpanm_lines.unshift "#!/usr/bin/env perl\n"
    (bin/"cpanm").atomic_write cpanm_lines.join
  end

  test do
    assert_match "cpan.metacpan.org", stable.url, "Don't use git tags, their naming is misleading"
    system "#{bin}/cpanm", "--local-lib=#{testpath}/perl5", "Test::More"
  end
end
