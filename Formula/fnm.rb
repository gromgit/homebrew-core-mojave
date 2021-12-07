class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.28.2.tar.gz"
  sha256 "02bec72f9978fc2fd7b2671b25cc2bb019a64c0f2d2fe7ab72ec0add91288599"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fnm"
    sha256 cellar: :any_skip_relocation, mojave: "6e7a9ad47afe137da820cc5975a1a5f7877db4a2d903271401b9ab62b0f41daf"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read(bin/"fnm", "completions", "--shell=zsh")
  end

  test do
    system bin/"fnm", "install", "12.0.0"
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end
end
