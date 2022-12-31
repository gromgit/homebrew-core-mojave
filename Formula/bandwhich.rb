class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.20.0.tar.gz"
  sha256 "4bbf05be32439049edd50bd1e4d5a2a95b0be8d36782e4100732f0cc9f19ba12"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bandwhich"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a0961054d0248165ca5b6b47a2787f4974cdad2a428df7a42e2821f895c7783b"
  end

  depends_on "rust" => :build

  # patch build
  # upstream issue, https://github.com/imsnif/bandwhich/issues/258
  # upstream PR, https://github.com/imsnif/bandwhich/pull/259
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/96bfb409db46dfe53b76da7682ddcf650af45921/bandwhich/0.20.0.patch"
    sha256 "ea446f63c9e766ab9c987c83f1ca5f6759175df4e2b3e377604fd87a2b0b26de"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
