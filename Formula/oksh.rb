class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.2/oksh-7.2.tar.gz"
  sha256 "3340ca98b1d5a2800ebe7dba75312d8a4971a3fcff20fcd0d0ec5cf7b719427e"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oksh"
    sha256 cellar: :any_skip_relocation, mojave: "17bde85220e457da4dd444cdce683b6cab1b72d02e96f6f43e92fef88812ec7c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end
