class Spago < Formula
  desc "PureScript package manager and build tool"
  homepage "https://github.com/purescript/spago"
  url "https://github.com/purescript/spago/archive/refs/tags/0.20.4.tar.gz"
  sha256 "e2ef8604115556b39ec71301d85a3502502fd5972e40bac82cd556d6a128baff"
  license "BSD-3-Clause"
  head "https://github.com/purescript/spago.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spago"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6cafa44575410c427701a93afbe66e48c96eb1548f8e35572ffd1ec10ee01ca2"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "purescript"

  resource "docs-search-app-0.0.10.js" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/docs-search-app.js"
    sha256 "45dd227a2139e965bedc33417a895ec7cb267ae4a2c314e6071924d19380aa54"
  end

  resource "docs-search-app-0.0.11.js" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/docs-search-app.js"
    sha256 "0254c9bd09924352f1571642bf0da588aa9bdb1f343f16d464263dd79b7e169f"
  end

  resource "purescript-docs-search-0.0.10" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/purescript-docs-search"
    sha256 "437ac8b15cf12c4f584736a07560ffd13f4440cd0c44c3a6f7a29248a1ff8171"
  end

  resource "purescript-docs-search-0.0.11" do
    url "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/purescript-docs-search"
    sha256 "06dfcb9b84408527a2980802108fae6a5260a522013f67d0ef7e83946abe4dc2"
  end

  def install
    # Equivalent to make fetch-templates:
    resources.each do |r|
      r.stage do
        template = Pathname.pwd.children.first
        (buildpath/"templates").install template.to_s => "#{template.basename(".js")}-#{r.version}#{template.extname}"
      end
    end

    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    (bash_completion/"spago").write `#{bin}/spago --bash-completion-script #{bin}/spago`
    (zsh_completion/"_spago").write `#{bin}/spago --zsh-completion-script #{bin}/spago`
  end

  test do
    system bin/"spago", "init"
    assert_predicate testpath/"packages.dhall", :exist?
    assert_predicate testpath/"spago.dhall", :exist?
    assert_predicate testpath/"src"/"Main.purs", :exist?
    system bin/"spago", "build"
    assert_predicate testpath/"output"/"Main"/"index.js", :exist?
  end
end
