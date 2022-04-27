class GitRemoteHg < Formula
  include Language::Python::Virtualenv

  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.4.tar.gz"
  sha256 "916072d134cde65b7ffa7d1da1acaabb0f29b65c017d0560e907e7a94063d1b1"
  license "GPL-2.0"
  revision 2
  head "https://github.com/felipec/git-remote-hg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "efcac93a209213486fcf837f83b364b6325adefba09493551e3e6017e669aa9f"
    sha256 cellar: :any_skip_relocation, mojave:      "3903ddefc5ed6142943aa33ba298ac51d054159f0c401bcde044934494202a19"
    sha256 cellar: :any_skip_relocation, high_sierra: "1380e5053a25462f27d9be329840b6dda55b08e01b70ed6c581f3c625c7b332d"
  end

  # Requires Python2.
  # https://github.com/Homebrew/homebrew-core/issues/93940
  deprecate! date: "2022-04-23", because: :unsupported

  depends_on "asciidoc" => :build
  depends_on :macos # Due to Python 2

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  conflicts_with "git-cinnabar", because: "both install `git-remote-hg` binaries"

  resource "hg" do
    url "https://www.mercurial-scm.org/release/mercurial-5.2.2.tar.gz"
    sha256 "ffc5ff47488c7b5dae6ead3d99f08ef469500d6567592a25311838320106c03b"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resource("hg")
    inreplace "git-remote-hg", /#!.*/, "#!#{libexec}/bin/python"
    system "make", "install", "prefix=#{prefix}"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install-doc", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
  end
end
