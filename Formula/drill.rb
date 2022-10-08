class Drill < Formula
  desc "HTTP load testing application written in Rust"
  homepage "https://github.com/fcsonline/drill"
  url "https://github.com/fcsonline/drill/archive/0.8.1.tar.gz"
  sha256 "8e31aa4d11898c801b6a47a6808b1545f1145520670971e4d12445ac624ff1af"
  license "GPL-3.0-or-later"
  head "https://github.com/fcsonline/drill.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/drill"
    sha256 cellar: :any_skip_relocation, mojave: "e0507c0b083b59585ca2c9ff59ba9f9cf30876d4929598a8e096ca07873dbbf8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  conflicts_with "ldns", because: "both install a `drill` binary"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"benchmark.yml").write <<~EOS
      ---
      concurrency: 4
      base: 'http://httpbin.org'
      iterations: 5
      rampup: 2

      plan:
        - name: Introspect headers
          request:
            url: /headers

        - name: Introspect ip
          request:
            url: /ip
    EOS

    assert_match "Total requests            10",
      shell_output("#{bin}/drill --benchmark #{testpath}/benchmark.yml --stats")
  end
end
