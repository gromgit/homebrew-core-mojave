class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.7.tar.gz"
  sha256 "05827aae15603ab8a3538a5c9df5d3571f8d28d9b5d52c50728fbc5b6f6bbfd6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-instruments"
    sha256 cellar: :any, mojave: "9a0c9ab1773e3f5c0d1505fb8c2aa47362412f4e42967d44c5bf7c3a977fb949"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
