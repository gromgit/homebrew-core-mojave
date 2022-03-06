class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f610e57396cac89aaa1070ab9edfd46f09929775b58dad2ba78ed8a59e01d6a1"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goawk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "54f3ce84a85c80a7a653fd5c73b741e81b426d7080a3fdfae0e86d67b7bf8d1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
