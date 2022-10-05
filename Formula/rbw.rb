class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.4.3.tar.gz"
  sha256 "2738aa6e868bf16292fcad9c9a45c60fe310d2303d06aea7875788bacda9b15b"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rbw"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c40e112644bc4df40b13ce6f665f9ff1d368fe83979e2530071353331b3b12c2"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
