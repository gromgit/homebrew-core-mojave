class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/v1.6.10.tar.gz"
  sha256 "18da0d25288deec7156ddd1d6923960968ab4adcdc917f85726b97d555d9b1b7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cointop"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "46bf035fe31dc6ccb04fde1df94f28e82572a9abb748b0571237a430baeb615c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/cointop-sh/cointop/cointop.version=#{version}")

    generate_completions_from_executable(bin/"cointop", "completion")
  end

  test do
    system bin/"cointop", "test"
  end
end
