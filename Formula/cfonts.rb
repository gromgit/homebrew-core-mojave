class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.0rust.tar.gz"
  sha256 "45c40dfc867234efc5c5a2df687ccfc40a6702fa5a82f2380b555f9e755508e6"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cfonts"
    sha256 cellar: :any_skip_relocation, mojave: "e84825cc7fd8f5fdd720602d1b6b276a99925fe47a37dbb464342269ec65ec06"
  end

  depends_on "rust" => :build

  def install
    chdir "rust" do
      system "make"
      system "cargo", "install", *std_cargo_args
      bin.install "target/release/cfonts"
    end
  end

  test do
    system bin/"cfonts", "--version"
    assert_match <<~EOS, shell_output("#{bin}/cfonts t")
      \n
      \ ████████╗
      \ ╚══██╔══╝
      \    ██║  \s
      \    ██║  \s
      \    ██║  \s
      \    ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end
