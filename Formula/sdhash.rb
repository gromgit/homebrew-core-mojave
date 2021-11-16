class Sdhash < Formula
  desc "Tool for correlating binary blobs of data"
  homepage "http://roussev.net/sdhash/sdhash.html"
  url "http://roussev.net/sdhash/releases/packages/sdhash-3.1.tar.gz"
  sha256 "b991d38533d02ae56e0c7aeb230f844e45a39f2867f70fab30002cfa34ba449c"
  revision 2

  bottle do
    sha256 cellar: :any, catalina:    "2b9a824cc177fe984f61eb756447e77f947b993317c6c5909fc5e56f52d7ab5f"
    sha256 cellar: :any, mojave:      "ff3ebba92126bd9ac537d4c6b7b0e818ca1318eb41fe410d9cbbbf7efde68ac2"
    sha256 cellar: :any, high_sierra: "81064cc409fb71b361a4be539ccf8d014dc5adf0186d666d00025d2109ff5168"
    sha256 cellar: :any, sierra:      "3d019e14266847dcfa7fa27f69ffa4aea25cc78a2ff62c1883a2a8c74fa02116"
  end

  # This version does not build on Big Sur, and the project seems to be unmaintained overall:
  # * The homepage says that the latest version is 3.4, but github says 4.0 is
  # * Even the github hasn't had a commit made to it since 2013 https://github.com/sdhash/sdhash/commits/master
  # * Seems to have Python 2 dependencies.  There is an open PR on the project to
  #   make it compatible with Python 3.7, but so far it hasn't been merged
  # If there is ever a post-4.0 release on github this formula might be resurrected
  # but for now it seems dead.
  disable! date: "2020-12-06", because: :does_not_build

  depends_on "openssl@1.1"

  def install
    inreplace "Makefile" do |s|
      # Remove space between -L and the path (reported upstream)
      s.change_make_var! "LDFLAGS",
                         "-L. -L./external/stage/lib -lboost_regex -lboost_system -lboost_filesystem " \
                         "-lboost_program_options -lc -lm -lcrypto -lboost_thread -lpthread"
    end
    system "make", "boost"
    system "make", "stream"
    bin.install "sdhash"
    man1.install Dir["man/*.1"]
  end

  test do
    system "#{bin}/sdhash"
  end
end
