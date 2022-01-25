class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.1.210/h2-2022-01-17.zip"
  version "2.1.210"
  sha256 "f3a82b598526270b60ea60d439e21bd290bacc2d18d262512bb9b37748055691"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "638ded79dfd9abaaac869f8ef7ef9aec709766e1ada24feb928ff2b22b297da2"
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
