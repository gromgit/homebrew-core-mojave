class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.29/openldap-LMDB_0.9.29.tar.bz2"
  sha256 "182e69af99788b445585b8075bbca89ae8101069fbeee25b2756fb9590e833f8"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lmdb"
    rebuild 4
    sha256 cellar: :any, mojave: "926f4eb3a985f3facec15c6bb1301fddc6aaed0d041241fb41f2dd6f31b80d2f"
  end

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
