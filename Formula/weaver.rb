class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.3.tar.gz"
  sha256 "d1fd7d767a4b5cea852378046c6bc9eb50a252aeb3dc96feb5c0128c60472f96"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weaver"
    sha256 cellar: :any_skip_relocation, mojave: "76c5839b875b9fae93b09197547f962822ddbb3e8e1c59dfba104a989eae73de"
  end

  depends_on xcode: ["11.2", :build]

  uses_from_macos "swift"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end
