class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.8.1.tar.gz"
  sha256 "5bea713b211dcd85599c697a0f6563e07e2c04fd1443416545eea0a9a83a4f8d"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aerc"
    sha256 cellar: :any_skip_relocation, mojave: "b734b8f43004766601c23effbc111e38770031fc7173c2bba4d86f06c8b69472"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
