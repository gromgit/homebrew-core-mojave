class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.0.tar.gz"
  sha256 "b6ea521ce3bbd0f55d0f8b61181312bb23a4da6d3605fe449d080abeffe09d91"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weaver"
    sha256 cellar: :any_skip_relocation, mojave: "36590ae19fcbb2774d796d33d797ea18025375b7cbd89b4ae9d430544c23c963"
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
