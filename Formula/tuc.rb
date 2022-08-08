class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e8208e0cb92bd17b36e1d43f0ea9d45f4573222fa40ca576775b4ebbb6442adf"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tuc"
    sha256 cellar: :any_skip_relocation, mojave: "cd6cd679744055d4bb41ef076bea1fb442901a734535363642957c3c28146894"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "regex", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/tuc -e '[, ]+' -f 1,3", "a,b, c")
    assert_equal "ac\n", output
  end
end
