class Bvm < Formula
  desc "Version manager for all binaries"
  homepage "https://github.com/bvm/bvm"
  url "https://github.com/bvm/bvm/archive/0.4.2.tar.gz"
  sha256 "d60c2e49bdac1facd9c17e21e3dac52767ead2fd50b1a94f484fb6d180b0acbd"
  license "MIT"
  head "https://github.com/bvm/bvm.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bvm"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2620e687a8bf1e9d5d88ce45d590ec0ea48d6df59f8e4221a8daf7fc97c8f758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    bin.install_symlink "bvm-bin" => "bvm"
  end

  test do
    ENV["BVM_INSTALL_DIR"] = testpath

    system bin/"bvm", "init"
    assert_predicate testpath/"bvm.json", :exist?

    system bin/"bvm", "install", "https://bvm.land/deno/1.3.2.json"
    assert_predicate testpath/".bvm/binaries/denoland/deno/1.3.2/bin/deno", :exist?

    assert_match version.to_s, shell_output("#{bin}/bvm --version")
  end
end
