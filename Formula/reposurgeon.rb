class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.32/reposurgeon-4.32.tar.gz"
  sha256 "5ebb884dda0abde29114fa7f20bdbc11aff8a50ddd6f017052f944799faccec5"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reposurgeon"
    sha256 cellar: :any_skip_relocation, mojave: "cfbece26b7c0221d2b6f797eabcbf903eaaf4f7e11a328c8087d51464a617b6b"
  end

  depends_on "asciidoctor" => :build
  depends_on "gawk" => :build if MacOS.version <= :catalina
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
