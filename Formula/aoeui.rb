class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://code.google.com/archive/p/aoeui/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/aoeui/aoeui-1.6.tgz"
  sha256 "0655c3ca945b75b1204c5f25722ac0a07e89dd44bbf33aca068e918e9ef2a825"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "daa6bd80f0cf479ba65187c2834ce38add2aeb37f93094596dcac9eda5001a68"
    sha256 cellar: :any_skip_relocation, big_sur:       "80411e75607878170abd4516b4ff368d8b4a8d1da0855c540d069d5b4cb88464"
    sha256 cellar: :any_skip_relocation, catalina:      "79a6d037053bc2b3fcd21870ccc274ad02f8e47bde5c9755b8665c25609ddd3a"
    sha256 cellar: :any_skip_relocation, mojave:        "c1e5c83add4ecaae6e45f5bed048045a0b2e81794244daf93028161bdd71e031"
    sha256 cellar: :any_skip_relocation, high_sierra:   "946acae5b1b88cb67bf805e6b8a8d591e3267d799c9d1a924e60217218166e78"
    sha256 cellar: :any_skip_relocation, sierra:        "1b04b93c490895121fed315f685d60cb96551b971ca1433a5240425cfa31dfcd"
    sha256 cellar: :any_skip_relocation, el_capitan:    "62a04ac0fd27e76f4f77da95e7d5aaf75488765f98b02574ae7dff0508cd9f13"
    sha256 cellar: :any_skip_relocation, yosemite:      "19f622466c20ad4ddff2fc97ac186e189d5a8bb02dd405ed2a93c5d13a88b1f4"
  end

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
