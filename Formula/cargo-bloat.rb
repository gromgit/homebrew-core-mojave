class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/v0.11.0.tar.gz"
  sha256 "16be80bb0486cb0a2fd9164402b2d7449b07c18738a6259d42035c738d3b4a32"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-bloat"
    sha256 cellar: :any_skip_relocation, mojave: "9b6f29d8a63108147ccab70e6d891583afc5811a949f207bd2abf58968b862a5"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("#{bin}/cargo-bloat --release -n 10 2>&1", 1)
      assert_match "Error: can be run only via `cargo bloat`", output
      output = shell_output("cargo bloat --release -n 10 2>&1")
      assert_match "Analyzing target/release/hello_world", output
    end
  end
end
