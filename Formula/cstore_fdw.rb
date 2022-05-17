class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cstore_fdw"
    sha256 cellar: :any, mojave: "58512608d33a986bd0f7287a21e2553de748cf27ca32f2535d6cf4d438ae50f6"
  end

  depends_on "postgresql@13"
  depends_on "protobuf-c"

  # PG13 support from https://github.com/citusdata/cstore_fdw/pull/243/
  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/b43b14829143203c3effc10537fa5636bad11c16.patch?full_index=1"
    sha256 "8576e3570d537c1c2d3083c997a8425542b781720e01491307087a0be3bbb46c"
  end
  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/71949ec5f1bd992b2627a6f9f6cfe8be9196e98f.patch?full_index=1"
    sha256 "fe812d2b7a52e7d112480a97614c03f6161d30d399693fae8c80ef3f2a61ad04"
  end

  def install
    # Makefile has issues with parallel builds: https://github.com/citusdata/cstore_fdw/issues/230
    ENV.deparallelize

    # Help compiler find postgresql@13 headers because they are keg-only
    # Try to remove when cstore_fdw supports postgresql 14.
    inreplace "Makefile", "PG_CPPFLAGS = --std=c99",
      "PG_CPPFLAGS = -I#{Formula["postgresql@13"].opt_include}/postgresql/server --std=c99"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql@13"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    pgsql_prefix = Formula["postgresql@13"].prefix.realpath
    pgsql_stage_path = File.join("stage", pgsql_prefix)
    (lib/"postgresql@13").install (buildpath/pgsql_stage_path/"lib/postgresql").children

    pgsql_opt_prefix = Formula["postgresql@13"].prefix
    pgsql_opt_stage_path = File.join("stage", pgsql_opt_prefix)
    share.install (buildpath/pgsql_opt_stage_path/"share").children
  end

  test do
    expected = "foreign-data wrapper for flat cstore access"
    assert_match expected, (share/"postgresql@13/extension/cstore_fdw.control").read
  end
end
