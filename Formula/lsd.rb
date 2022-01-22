class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.21.0.tar.gz"
  sha256 "f500c18221f9c3fd45f88f6f764001e99cf9d6d74af9172cbb9a9ff32f3e5c7d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsd"
    sha256 cellar: :any_skip_relocation, mojave: "52989ca272c507b07c07eb37ceb114fc219715d0bb385d461ee7610b18b73fbb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
