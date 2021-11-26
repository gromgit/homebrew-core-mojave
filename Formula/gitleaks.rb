class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.0.tar.gz"
  sha256 "6643ad25a5f5b42df0835b770848aef1993d770f09cfc9a1e6bcadcf71d7a2cc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitleaks"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "65103a1d9743ff5fd8a3d5b366010d2359af1a2886dc43dd7866f0349dd2909c"
  end

  depends_on "go" => :build
  uses_from_macos "git", since: :big_sur # git 2.27+

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
