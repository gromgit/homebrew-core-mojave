class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/howtowhale/dvm"
  url "https://github.com/howtowhale/dvm/archive/1.0.3.tar.gz"
  sha256 "148c2c48a17435ebcfff17476528522ec39c3f7a5be5866e723c245e0eb21098"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dvm"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c99e8e0762b53b38b9a0e0a0402273b0f5797cc808941d54d057b9e8c6932cba"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}", "UPGRADE_DISABLED=true"
    prefix.install "dvm.sh"
    bash_completion.install "bash_completion" => "dvm"
    (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
  end

  def caveats
    <<~EOS
      dvm is a shell function, and must be sourced before it can be used.
      Add the following command to your bash profile:
          [ -f #{opt_prefix}/dvm.sh ] && . #{opt_prefix}/dvm.sh
    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end
