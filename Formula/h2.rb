class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.0.202/h2-2021-11-25.zip"
  version "2.0.202"
  sha256 "cd863f2b2877be1bcb4d2419cfc799a8ae07a96c19a9760807fe778387736750"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de2473255b0ce9d5570314b0d733482af275dd5119d46c91c59e51c32aa594a8"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the script
    # upstream issue, https://github.com/h2database/h2database/issues/3254
    chmod 0755, "bin/h2.sh"

    libexec.install Dir["*"]
    (bin/"h2").write_env_script libexec/"bin/h2.sh", Language::Java.overridable_java_home_env
  end

  service do
    run [opt_bin/"h2", "-tcp", "-web", "-pg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}/h2 -help 2>&1")
  end
end
