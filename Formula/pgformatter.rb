class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.2.tar.gz"
  sha256 "78bfc77f54f33d948f9b2e2cd061ceee0b970e263a403603635cfec61e955ae0"
  license "PostgreSQL"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgformatter"
    sha256 cellar: :any_skip_relocation, mojave: "4e703ce8286b08ecfa5d994f8bf0837ffc07af09eb93b011deb73340798e4983"
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
