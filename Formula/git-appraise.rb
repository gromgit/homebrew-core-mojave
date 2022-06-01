class GitAppraise < Formula
  desc "Distributed code review system for Git repos"
  homepage "https://github.com/google/git-appraise"
  license "Apache-2.0"
  head "https://github.com/google/git-appraise.git", branch: "master"

  stable do
    url "https://github.com/google/git-appraise/archive/v0.7.tar.gz"
    sha256 "b57dd4ac4746486e253658b2c93422515fd8dc6fdca873b5450a6fb0f9487fb3"

    # Backport go.mod from https://github.com/google/git-appraise/pull/111
    patch :DATA
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-appraise"
    sha256 cellar: :any_skip_relocation, mojave: "6312ff9230ac1ddadeadf427a6fdbb0654a6f2577a6154831adac1bf0bfb968a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-appraise"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "user@email.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Init"
    system "git", "branch", "user/test"
    system "git", "checkout", "user/test"
    (testpath/"README").append_lines "test2"
    system "git", "add", "README"
    system "git", "commit", "-m", "Update"
    system "git", "appraise", "request", "--allow-uncommitted"
    assert_predicate testpath/".git/refs/notes/devtools/reviews", :exist?
  end
end

__END__
diff --git a/go.mod b/go.mod
new file mode 100644
index 00000000..28bed68b
--- /dev/null
+++ b/go.mod
@@ -0,0 +1,5 @@
+module github.com/google/git-appraise
+
+go 1.18
+
+require golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12
diff --git a/go.sum b/go.sum
new file mode 100644
index 00000000..b22c466b
--- /dev/null
+++ b/go.sum
@@ -0,0 +1,2 @@
+golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12 h1:QyVthZKMsyaQwBTJE04jdNN0Pp5Fn9Qga0mrgxyERQM=
+golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
