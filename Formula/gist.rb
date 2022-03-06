class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v6.0.0.tar.gz"
  sha256 "ddfb33c039f8825506830448a658aa22685fc0c25dbe6d0240490982c4721812"
  license "MIT"
  head "https://github.com/defunkt/gist.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gist"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b6ab41e62cadacc08d55445e1c152ac614d291d81a22af13c64a17efa0f33af6"
  end

  uses_from_macos "ruby", since: :high_sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end
