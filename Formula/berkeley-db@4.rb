class BerkeleyDbAT4 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-4.8.30.tar.gz"
  sha256 "e0491a07cdb21fb9aa82773bbbedaeb7639cbd0e7f96147ab46141e0045db72a"
  license "Sleepycat"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "ec19587b4fb0d7ee44a351aed1ed2912e327acdd4de816baee6ec9f3a9dfc7ff"
    sha256 cellar: :any,                 arm64_big_sur:  "4cc3d7123506a695892eb450c704ae6a2f26fd865dcab7bb9290431c5ed4add5"
    sha256 cellar: :any,                 monterey:       "7b227d2e4f39efef969bc407bc04c5bbf7f2cfcce6e0e731680342777dd7f2be"
    sha256 cellar: :any,                 big_sur:        "8a95577ecc798d7dd61b100d282c3b667eb278b3d719a41331db2cc57e0843c1"
    sha256 cellar: :any,                 catalina:       "3ef8ec895927523c7a7c2c8c18af534ed00abd9b0d35664a3464595906adcee4"
    sha256 cellar: :any,                 mojave:         "06af286b14463aec20a0bc9560a6c4081fb392325a8bb8403dd7f02ac4076711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41de3e62651a2b5b8a3ae23b18b1331478c38fac38c1446627cd0d82c1e657d8"
  end

  keg_only :versioned_formula

  # Fix build with recent clang
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4c55b1/berkeley-db%404/clang.diff"
    sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # Work around issues ./configure has with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+"docs", doc
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <string.h>
      #include <db_cxx.h>
      int main() {
        Db db(NULL, 0);
        assert(db.open(NULL, "test.db", NULL, DB_BTREE, DB_CREATE, 0) == 0);

        const char *project = "Homebrew";
        const char *stored_description = "The missing package manager for macOS";
        Dbt key(const_cast<char *>(project), strlen(project) + 1);
        Dbt stored_data(const_cast<char *>(stored_description), strlen(stored_description) + 1);
        assert(db.put(NULL, &key, &stored_data, DB_NOOVERWRITE) == 0);

        Dbt returned_data;
        assert(db.get(NULL, &key, &returned_data, 0) == 0);
        assert(strcmp(stored_description, (const char *)(returned_data.get_data())) == 0);

        assert(db.close(0) == 0);
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
    assert_predicate testpath/"test.db", :exist?
  end
end
