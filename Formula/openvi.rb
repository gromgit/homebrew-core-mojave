class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.1.18.tar.gz"
  sha256 "39c4ac933f52c65021be06fcece8bfd308fc1ac08e8ff4604b2fdd1994192d08"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openvi"
    sha256 cellar: :any_skip_relocation, mojave: "fbeaa316452c1e8a4ccd8f236f8260fa85d85a9392a95c6c74a78ae9300ba889"
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
