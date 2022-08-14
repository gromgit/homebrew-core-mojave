class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.3.tar.gz"
  sha256 "ad709a2c92c763d54088ae3f3002276a962ea25b5aa29ae16dd57e10f51b66f9"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgformatter"
    sha256 cellar: :any_skip_relocation, mojave: "e475bf116f1638ceafe659f0dd8685a70b9b2466256e927de8d14dd8655a7b3f"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    if OS.linux?
      # Move man pages to share directory so they will be linked correctly on Linux
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
