class Detach < Formula
  desc "Execute given command in detached process"
  homepage "http://inglorion.net/software/detach/"
  url "http://inglorion.net/download/detach-0.2.3.tar.bz2"
  sha256 "b2070e708d4fe3a84197e2a68f25e477dba3c2d8b1f9ce568f70fc8b8e8a30f0"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?detach[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/detach"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fd8a14f22bfe090e6d6f411d569012a06862fc9030547cc391d9c825738dc300"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "detach"
    man1.install "detach.1"
  end

  test do
    system "#{bin}/detach", "-p", "#{testpath}/pid", "sh", "-c", "sleep 10"
    pid = (testpath/"pid").read.to_i
    ppid = shell_output("ps -p #{pid} -o ppid=").to_i
    assert_equal 1, ppid
    Process.kill "TERM", pid
  end
end
