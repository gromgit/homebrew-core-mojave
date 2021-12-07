class Frum < Formula
  desc "Fast and modern Ruby version manager written in Rust"
  homepage "https://github.com/TaKO8Ki/frum/"
  url "https://github.com/TaKO8Ki/frum/archive/v0.1.2.tar.gz"
  sha256 "0a67d12976b50f39111c92fa0d0e6bf0ae6612a0325c31724ea3a6b831882b5d"
  license "MIT"
  head "https://github.com/TaKO8Ki/frum.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frum"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "b192063b21a67e329817e8d01f1ead08df3566d4818e15ac09f407836adccba4"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"frum").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=bash")
    (fish_completion/"frum.fish").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=fish")
    (zsh_completion/"_frum").write Utils.safe_popen_read(bin/"frum", "completions", "--shell=zsh")
  end

  test do
    available_versions = shell_output("#{bin}/frum install -l").split("\n")
    assert_includes available_versions, "2.6.5"
    assert_includes available_versions, "2.7.0"

    frum_dir = (testpath/".frum")
    mkdir_p frum_dir/"versions/2.6.5"
    mkdir_p frum_dir/"versions/2.4.0"
    versions = shell_output("eval \"$(#{bin}/frum init)\" && frum versions").split("\n")
    assert_equal 2, versions.length
    assert_includes versions, "  2.4.0"
    assert_includes versions, "  2.6.5"
  end
end
