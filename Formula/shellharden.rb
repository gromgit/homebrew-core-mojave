class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.2.0.tar.gz"
  sha256 "468406c3698c98deeabbcb0b933acec742dcd6439c24d85c60cd3d6926ffd02c"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shellharden"
    sha256 cellar: :any_skip_relocation, mojave: "fcaf3e187b632331a591e25f4ce17da9107556bb67c1a8561ddd10b488ad2ae5"
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
