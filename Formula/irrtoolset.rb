class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://github.com/irrtoolset/irrtoolset/archive/release-5.1.3.tar.gz"
  sha256 "a3eff14c2574f21be5b83302549d1582e509222d05f7dd8e5b68032ff6f5874a"
  license :cannot_represent
  head "https://github.com/irrtoolset/irrtoolset.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/[^"' >]*?v?(\d+(?:[._-]\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/irrtoolset"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7f9f5ab2b3282b8b934a68ad2e30915ea53dd7a57c678bef8e4dea1e6d55e9a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Uses newer syntax than system Bison supports
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    system "autoreconf", "-iv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/peval", "ANY"
  end
end
