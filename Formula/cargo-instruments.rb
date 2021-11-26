class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.4.tar.gz"
  sha256 "e71b29af433f5701483827620866fd6302999d08ddb559578261951da15601cc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-instruments"
    rebuild 1
    sha256 cellar: :any, mojave: "8ae125bf9fe9f010cc01db438425e7a9e0d8c5a4fdfb6b657d0fd6ae747f4786"
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
