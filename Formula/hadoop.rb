class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  sha256 "b341587495b12eec0b244b517f21df88eb46ef634dc7dc3e5969455b80ce2ce5"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hadoop"
    sha256 cellar: :any_skip_relocation, mojave: "ff9fc2728e7cf70c56c4dab0423c5d666e3d08ba32d336a7f8ea911f8c57f24d"
  end

  depends_on "openjdk"

  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    Dir["#{libexec}/bin/*"].each do |path|
      (bin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/sbin/*"].each do |path|
      (sbin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/libexec/*.sh"].each do |path|
      (libexec/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    # Temporary fix until https://github.com/Homebrew/brew/pull/4512 is fixed
    chmod 0755, Dir["#{libexec}/*.sh"]
  end

  test do
    system bin/"hadoop", "fs", "-ls"
  end
end
