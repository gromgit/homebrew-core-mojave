class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9b359c2c7e78d418266654e4c94988b0495ddea62391fcf51512038dd3109146"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/viu"
    sha256 cellar: :any_skip_relocation, mojave: "dabe9478c1c6bcb0340b99384b916402724225eeca774c73669f32fe871aa502"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
