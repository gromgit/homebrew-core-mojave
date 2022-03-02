class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  url "https://raw.githubusercontent.com/Factual/drake/1.0.3/bin/drake-pkg"
  sha256 "adeb0bb14dbe39789273c5c766da9a019870f2a491ba1f0c8c328bd9a95711cc"
  license "EPL-1.0"
  head "https://github.com/Factual/drake.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/drake"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cfe22cd2892ea6b536d21c1454b42fcbf1e36e843f18be3e39683cdfef456819"
  end


  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/1.0.3/drake.jar"
    sha256 "c9c5b109a900b6f30257425feee7a4e05ef11cc34cf227b04207a2f8645316af"
  end

  def install
    jar = "drake-#{version}-standalone.jar"
    inreplace "drake-pkg", "DRAKE_JAR", libexec/jar

    libexec.install "drake-pkg" => "drake"
    chmod 0755, libexec/"drake"
    (bin/"drake").write_env_script libexec/"drake", Language::Java.overridable_java_home_env("1.8")

    resource("jar").stage do
      libexec.install "drake.jar" => jar
    end
  end

  test do
    # count lines test
    (testpath/"Drakefile").write <<~EOS
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
