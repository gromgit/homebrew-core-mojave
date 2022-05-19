class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.6.tar.gz"
  sha256 "fc68a66a216e304bb0e2ef627f767fff528f4fbf2bbda27e8cd8db1b7ba090b0"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgroonga"
    rebuild 1
    sha256 cellar: :any, mojave: "f5a0f77144ce5e8fd3fd8804f29ce6147a0a8e5d28ce5d6dd7405abab6d15c4a"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
  end

  test do
    expected = "PGroonga database management module"
    assert_match expected, (share/"postgresql/extension/pgroonga_database.control").read
  end
end
