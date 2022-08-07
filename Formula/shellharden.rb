class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.3.0.tar.gz"
  sha256 "d17bf55bae4ed6aed9f0d5cea8efd11026623a47b6d840b826513ab5b48db3eb"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shellharden"
    sha256 cellar: :any_skip_relocation, mojave: "a424c4e3e81e75c6d1ad7042b275827cf63f18d6c1e8dc9b8f47141bcf9ce8bb"
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
