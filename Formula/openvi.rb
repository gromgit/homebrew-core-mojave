class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.1.17.tar.gz"
  sha256 "02974603f1cd3ba5727fd40f69f97925510d8f30c1ff3041adbc3e54e11f6d5f"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openvi"
    sha256 cellar: :any_skip_relocation, mojave: "defd03d6f4fca84c875ebbf15a4d375217213ae03c804d3a2435d9166663da78"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
