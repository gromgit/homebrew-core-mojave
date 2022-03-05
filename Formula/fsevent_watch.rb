class FseventWatch < Formula
  desc "macOS FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.2.tar.gz"
  sha256 "1cfd66d551bb5a7ef80b53bcc7952b766cf81ce2059aacdf7380a9870aa0af6c"
  license "MIT"
  head "https://github.com/proger/fsevent_watch.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fsevent_watch"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "24ca3296f24d34d45152a300acd9fcd303890f4fe08116699ef02adff4dfb285"
  end

  depends_on :macos

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "#{bin}/fsevent_watch", "--version"
  end
end
