class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/v5.1.0.tar.gz"
  sha256 "33b3d00c3830c32927f555bf75ddc4d37ef7ee77b9ffda0e5d46162c4ffd0c9f"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grin-wallet"
    sha256 cellar: :any_skip_relocation, mojave: "1354e41f5f94b60fe2f18f0ac5eb3b8dcdb499050f02e131f6b6ca27147dcacb"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang" if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_predicate testpath/".grin/main/wallet_data/wallet.seed", :exist?
  end
end
