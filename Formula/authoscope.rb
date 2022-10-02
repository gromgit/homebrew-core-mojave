class Authoscope < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/authoscope"
  url "https://github.com/kpcyrd/authoscope/archive/v0.8.1.tar.gz"
  sha256 "fd70d3d86421ac791362bf8d1063a1d5cd4f5410b0b8f5871c42cb48c8cc411a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/authoscope"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "52b2cbecb35bb37097a926fc61b24279091e9b6ff80bcdf2009ec9c8dc152ba4"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "docs/authoscope.1"

    generate_completions_from_executable(bin/"authoscope", "completions")
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system bin/"authoscope", "run", "-vvx", testpath/"true.lua", "foo"
  end
end
