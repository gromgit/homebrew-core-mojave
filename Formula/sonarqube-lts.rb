class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.7.52159.zip"
  sha256 "ce528344a384d0ee5b6ad44b242005a0053914683311ea967c43ff86c81fcc94"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LTS.*?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sonarqube-lts"
    sha256 cellar: :any_skip_relocation, mojave: "e41a86c12561121a76952c05fd5da5c3f329f2a3f788b863e51241808596ddad"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk@11"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Use Java Service Wrapper 3.5.46 which is Apple Silicon compatible
    # Java Service Wrapper doesn't support the  wrapper binary to be symlinked, so it's copied
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec/"lib/wrapper.jar", "#{buildpath}/lib/jsw/wrapper-3.5.46.jar"
    ln_s jsw_libexec/"lib/libwrapper.dylib", "#{buildpath}/bin/macosx-universal-64/lib/"
    cp jsw_libexec/"bin/wrapper", "#{buildpath}/bin/macosx-universal-64/"
    cp jsw_libexec/"scripts/App.sh.in", "#{buildpath}/bin/macosx-universal-64/sonar.sh"
    sonar_sh_file = "bin/macosx-universal-64/sonar.sh"
    inreplace sonar_sh_file, "@app.name@", "SonarQube"
    inreplace sonar_sh_file, "@app.long.name@", "SonarQube"
    inreplace sonar_sh_file, "../conf/wrapper.conf", "../../conf/wrapper.conf"
    inreplace "conf/wrapper.conf", "wrapper-3.2.3.jar", "wrapper-3.5.46.jar"
    rm "lib/jsw/wrapper-3.2.3.jar"
    rm "bin/macosx-universal-64/lib/libwrapper.jnilib"

    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
