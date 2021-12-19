class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.32.tar.gz"
  sha256 "a894cfa96c44b9ef48003b2c2104dc5fa6361dd2f4d519261a93178984a51259"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  revision 1
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bup"
    sha256 cellar: :any_skip_relocation, mojave: "bc506453fb2a4c654065c2e2ee71eccc7b122c6fc77d92876a0a8669d8302b27"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
