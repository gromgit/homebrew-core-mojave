class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 3

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.uka.de/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pktanon"
    sha256 cellar: :any, mojave: "6c4d51ce72312a72ac7d9c263c9a41aede9e9efc494c98ec56fb8d9ef9bb7b6f"
  end

  depends_on "boost"
  depends_on "xerces-c"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
