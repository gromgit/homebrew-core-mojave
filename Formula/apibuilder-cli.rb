class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.43.tar.gz"
  sha256 "69c8c100ba9d56e83c146b5338c2a68c189fc6d1ca2eb184f357a84091224077"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "635386febe5f3684c6ad68bc0a3372dfe899042ecd6fcb73f0a7e0ac39f8dfc1"
  end

  uses_from_macos "ruby"

  # Fix compatibility with Ruby 3.2.
  # https://github.com/apicollective/apibuilder-cli/pull/85
  patch do
    url "https://github.com/apicollective/apibuilder-cli/commit/63f84f3f021ef11eb75304bdd902950fb7cafb49.patch?full_index=1"
    sha256 "0a99973808f37455f544fad91d677107418f008a8baff3bb59a47add63c6401e"
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
