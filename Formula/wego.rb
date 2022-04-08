class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/2.1.tar.gz"
  sha256 "cebfa622789aa8e7045657d81754cb502ba189f4b4bebd1a95192528e06969a6"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wego"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b3c6130cba35f96cb111881dd4ac9f759cc7999262eb949fbdf082ff4628b116"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
