class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "https://shibboleth.net/downloads/log4shib/2.0.1/log4shib-2.0.1.tar.gz"
  sha256 "aad37f3929bd3d4c16f09831ff109c20ae8c7cb8b577917e3becb12f873f26df"
  license "LGPL-2.1"

  livecheck do
    url "https://shibboleth.net/downloads/log4shib/latest/"
    regex(/href=.*?log4shib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/log4shib"
    rebuild 1
    sha256 cellar: :any, mojave: "284ad2aa2118d7b43b83b81c12a7b86a9c49d9784eafe6319bc4c7be9ef6e9f6"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
    (pkgshare/"test").install %w[tests/log4shib.init tests/testConfig.cpp tests/testConfig.log4shib.properties]
  end

  test do
    cp_r (pkgshare/"test").children, testpath
    system ENV.cxx, "testConfig.cpp", "-I#{include}", "-L#{lib}", "-llog4shib", "-o", "test", "-pthread"
    system "./test"
  end
end
