class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "6f5b01de19a1c3376a714c9636aa8d4497d060826a5656cb94785fb4be3468e5"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hurl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6d0bdc0cac5551606f25e8af81fd5b7dc19e48d131e9f3ca98c4e0439fc58257"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.hurl")
    filename.write "GET https://hurl.dev"
    system "#{bin}/hurl", "--color", filename
    system "#{bin}/hurlfmt", "--color", filename
  end
end
