class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.44.tar.gz"
  sha256 "825aef5815fb6eff656370e9f01fc31f91e5b2ab9d2b1f080881839676020dac"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/efm-langserver"
    sha256 cellar: :any_skip_relocation, mojave: "82449e9d9af5148a61134aeaf166ecaba6709d3cf797f66a397d1b2e908f7980"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
