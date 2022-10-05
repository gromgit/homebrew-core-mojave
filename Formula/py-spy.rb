class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "c01da8b74be0daba79781cfc125ffcd3df3a0d090157fe0081c71da2f6057905"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/py-spy"
    sha256 cellar: :any_skip_relocation, mojave: "16561baa9ee27e71e5ce66cbfa364a4dda35e5ad1836c34488ce5984b16c35f4"
  end

  depends_on "rust" => :build
  depends_on "python@3.10" => :test

  on_linux do
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
