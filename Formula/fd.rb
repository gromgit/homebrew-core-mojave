class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.6.0.tar.gz"
  sha256 "e71a139f9ca20f63bab3700d5f8810bc12ef2c4fc6e1dd680f5c96fa9d1d2834"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fd"
    sha256 cellar: :any_skip_relocation, mojave: "7ca1acbecb76f82be586c2e3636507713a815a65c66ebc10076529d63e231226"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
