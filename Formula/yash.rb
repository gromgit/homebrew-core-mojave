class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/77664/yash-2.53.tar.xz"
  sha256 "e430ee845dfd7711c4f864d518df87dd78b40560327c494f59ccc4731585305d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.net/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yash"
    sha256 mojave: "5945c0a6a1623b4cdc1b3efd980ae76faf82b8078d506edb7a927b3c4c503540"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  depends_on "gettext"

  def install
    system "sh", "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
