class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.105.1.tar.gz"
  mirror "https://fossies.org/linux/misc/clamav-0.105.1.tar.gz"
  sha256 "d2bc16374db889a6e5a6ac40f8c6e700254a039acaa536885a09eeea4b8529f6"
  license "GPL-2.0-or-later"
  head "https://github.com/Cisco-Talos/clamav-devel.git", branch: "main"

  livecheck do
    url "https://www.clamav.net/downloads"
    regex(/href=.*?clamav[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/clamav"
    sha256 mojave: "22f765b157d07260835a6fbcd3f2108321f2020f3b88efb87c5409d6e2c1c2e2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libiconv"
  end

  skip_clean "share/clamav"

  def install
    args = std_cmake_args + %W[
      -DAPP_CONFIG_DIRECTORY=#{etc}/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{etc}/clamav/
    EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS
    system "#{bin}/freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system "#{bin}/clamscan", "--database=#{testpath}", testpath
  end
end
