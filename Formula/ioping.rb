class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.2.tar.gz"
  sha256 "d3e4497c653a1e96df67c72ce2b70da18e9f5e3b93179a5bb57a6e30ceacfa75"
  license "GPL-3.0-or-later"
  head "https://github.com/koct9i/ioping.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ioping"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "33b14ba4c776058e7d8c7ea5dc81f8e080552049f8f6cf77b5f97c2b31fb2114"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
