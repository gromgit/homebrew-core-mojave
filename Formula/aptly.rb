class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.5.0.tar.gz"
  sha256 "07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aptly"
    sha256 cellar: :any_skip_relocation, mojave: "c8a82022326063c579dea9b86ecc76d46fd0db3e13af84f404f64f3cc0462a89"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/aptly-dev/aptly").install buildpath.children
    cd "src/github.com/aptly-dev/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
      bash_completion.install "completion.d/aptly"
      zsh_completion.install "completion.d/_aptly"
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
