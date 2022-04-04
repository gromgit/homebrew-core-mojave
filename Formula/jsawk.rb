class Jsawk < Formula
  desc "Like awk, but for JSON, using JavaScript objects and arrays"
  homepage "https://github.com/micha/jsawk"
  url "https://github.com/micha/jsawk/archive/1.4.tar.gz"
  sha256 "3d38ffb4b9c6ff7f17072a12c5817ffe68bd0ab58d6182de300fc1e587d34530"
  license "BSD-3-Clause"
  head "https://github.com/micha/jsawk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jsawk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b06e66e1e913ac5adf2bbff5953330a198b5729566e09d56efd6f2d035579dcf"
  end

  depends_on "spidermonkey"

  def install
    bin.install "jsawk"
  end

  test do
    cmd = %Q(#{bin}/jsawk 'this.a = "foo"')
    assert_equal %Q({"a":"foo"}\n), pipe_output(cmd, "{}")
  end
end
