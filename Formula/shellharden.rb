class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.1.3.tar.gz"
  sha256 "1ea7f3af1346738689bf41f2be2a8be2285c2d66b55fe71999c0d82f50a1bdc0"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shellharden"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "77c24d8da9328d802a9eba8dafd94fb3253e5d8326abc7b755b050a45ab898f5"
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
