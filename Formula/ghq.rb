class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.2.1",
      revision: "dd139fb46cb7c1a3b19bca7a0c3762090c7c522f"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghq"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "70a3ba0cf9f4bb8660e956b79c636af8e81a88289708aba3639d79651c2607ff"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
