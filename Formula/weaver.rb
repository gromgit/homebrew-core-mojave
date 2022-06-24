class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.1.tar.gz"
  sha256 "2c82cafa133002addc106f4bcdac1ea32ed50eddf98b63422ce28ff5f086e508"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weaver"
    sha256 cellar: :any_skip_relocation, mojave: "93b51bdb1c859cddf0d03cb3d69b297dc638e0d8d586c56a5620d1e1282b465d"
  end

  depends_on xcode: ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end
