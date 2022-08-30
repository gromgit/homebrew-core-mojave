class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.3.tar.gz"
  sha256 "7aa48e70aaa766bc112dea57ebbe56700626871052380709df3a26f46766e8c8"
  license "GPL-3.0-or-later"
  head "https://github.com/koct9i/ioping.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioping"
    sha256 cellar: :any_skip_relocation, mojave: "314f99ca6aee88aed56b004e400f6bde458d43d63d99459952377d2329ac52ea"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
