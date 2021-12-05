class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.3.tar.gz"
  sha256 "45231c50d15b5d863e8f683d9e8277656e012ca4ba11cf42722d01741c9243bb"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/citus"
    rebuild 2
    sha256 cellar: :any, mojave: "ba060220f0b85c062c610cbdbb793b17c2b779f9b48e00ddb86f5bfff19f27a9"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
