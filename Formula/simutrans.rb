class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "10421"
  version "123.0.1"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/simutrans"
    sha256 cellar: :any, mojave: "c67fbcd25a29974925ba40b7961960ecfa3462e870df1003bc6db146cf0adbee"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "curl"
  uses_from_macos "unzip"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/123-0/simupak64-123-0.zip"
    sha256 "b8a0a37c682d8f62a3b715c24c49bc738f91d6e1e4600a180bb4d2e9f85b86c1"
  end

  def install
    # These translations are dynamically generated.
    system "./get_lang_files.sh"

    args = %w[
      BACKEND=sdl2
      MULTI_THREAD=1
      OPTIMISE=1
      USE_FREETYPE=1
      USE_UPNP=0
      USE_ZSTD=0
    ]
    if OS.mac?
      args << "AV_FOUNDATION=1" if MacOS.version >= :sierra
      args << "OSTYPE=mac"
    elsif OS.linux?
      args << "OSTYPE=linux"
    end

    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "all", *args
    cd "themes.src" do
      ln_s "../makeobj/makeobj", "makeobj"
      system "./build_themes.sh"
    end

    libexec.install "sim" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "makeobj/makeobj"
    bin.install "nettools/nettool"

    libexec.install resource("pak64")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
