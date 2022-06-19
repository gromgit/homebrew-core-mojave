class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.2.tar.gz"
  sha256 "86ab78b6efc4739c7de3af935317b7ef6a7646250d80ccc0ab31ad28fc49070a"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/citus"
    sha256 cellar: :any, mojave: "fd96b86dcb2a935382f9951d6c2fd3a78af3bf03431c4fabab210a1c5051b36d"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/path/"lib").children
    include.install (buildpath/path/"include").children
    (share/"postgresql/extension").install (buildpath/path/"share/postgresql/extension").children
  end
end
