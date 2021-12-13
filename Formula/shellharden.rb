class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.1.3.tar.gz"
  sha256 "1ea7f3af1346738689bf41f2be2a8be2285c2d66b55fe71999c0d82f50a1bdc0"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shellharden"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c8bc5fbcbb6a70867d62c9a453755980adfc31e5d027a894695f151f27a3b714"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"script.sh").write <<~EOS
      dog="poodle"
      echo $dog
    EOS
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
