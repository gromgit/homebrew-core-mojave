class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.5.tar.gz"
  sha256 "0a0b8359eccdd5d63eaa3b06b7a24aea813d7f1e8bf99536bdd60bc7f18dca03"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-remote-gcrypt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c06645a19c60befe35c368c418e52a4b52c1e352f274c360db7e2805511f359b"
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
