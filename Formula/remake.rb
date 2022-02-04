class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.3%2Bdbg-1.6/remake-4.3%2Bdbg-1.6.tar.gz"
  version "4.3-1.6"
  sha256 "f6a0c6179cd92524ad5dd04787477c0cd45afb5822d977be93d083b810647b87"
  license "GPL-3.0-only"

  # We check the "remake" directory page because the bashdb project contains
  # various software and remake releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/remake/"
    regex(%r{href=.*?remake/v?(\d+(?:\.\d+)+(?:(?:%2Bdbg)?[._-]\d+(?:\.\d+)+)?)/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub(/%2Bdbg/i, "") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/remake"
    sha256 mojave: "56ddace791b77aeaa3d0a6af1b7a1f313e62caef205f858859c75b4757e9aa2a"
  end

  depends_on "readline"

  conflicts_with "make", because: "both install texinfo files for make"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
