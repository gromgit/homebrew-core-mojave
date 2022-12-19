class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "85013be46725acc1cd6f2d2089c42f426c052efab26d22db8a9f28051eebbb6a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rnr"
    sha256 cellar: :any_skip_relocation, mojave: "c04a3256e2c973fe7dcfeb705c86d6bc75fded8b5476354141838a1bcda61178"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    deploy_dir = Dir["target/release/build/rnr-*/out"].first
    zsh_completion.install "#{deploy_dir}/_rnr" => "_rnr"
    bash_completion.install "#{deploy_dir}/rnr.bash" => "rnr"
    fish_completion.install "#{deploy_dir}/rnr.fish"
  end

  test do
    touch "foo.doc"
    mkdir "one"
    touch "one/foo.doc"

    system "#{bin}/rnr", "-f", "doc", "txt", "foo.doc", "one/foo.doc"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
