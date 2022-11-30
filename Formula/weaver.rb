class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.4.tar.gz"
  sha256 "d3bb488a618fa96e0c1b50db317ae7e9da9cb62d42c2da643731aa94f2fcb724"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/weaver"
    sha256 cellar: :any_skip_relocation, mojave: "e9e6e3aa1c81cf178907dbb7e9adc12671b8f5722a0e80567eb8f47b81f1532a"
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
