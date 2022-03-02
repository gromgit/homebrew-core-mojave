class FabricCompletion < Formula
  desc "Bash completion for Fabric"
  homepage "https://github.com/st3ldz/fabric-completion"
  url "https://github.com/st3ldz/fabric-completion.git",
      revision: "5b5910492046e6335af0e88550176d2583d9a510"
  version "1"
  head "https://github.com/st3ldz/fabric-completion.git", branch: "master"

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fabric-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b0d3423333e8d1e3268f31d9fe8ce4a41c904ba6fb6803dd9585467cb5734d9d"
  end


  def install
    bash_completion.install "fabric-completion.bash" => "fabric"
  end

  def caveats
    <<~EOS
      All available tasks are cached in special file to speed up the response.
      Therefore, Add .fab_tasks~ to your ".gitignore".

      For more details and configuration refer to the home page.
    EOS
  end

  test do
    assert_match "-F __fab_completion",
      shell_output("bash -c 'source #{bash_completion}/fabric && complete -p fab'")
  end
end
