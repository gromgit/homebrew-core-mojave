class Checkstyle < Formula
  desc "Check Java source against a coding standard"
  homepage "https://checkstyle.sourceforge.io/"
  url "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.3.3/checkstyle-10.3.3-all.jar"
  sha256 "2784f2ea76e50b29517f21dcc6a0d727a2c087683bf9c0feb8da2b5b5126c187"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6404adda5cf164cc302c40878422315cd4e792db0d2e0d134dcbb8593c19acfd"
  end

  depends_on "openjdk"

  def install
    libexec.install "checkstyle-#{version}-all.jar"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = shell_output("#{bin}/checkstyle -c /sun_checks.xml #{path}", 2)
    errors = output.lines.select { |line| line.start_with?("[ERROR] #{path}") }
    assert_match "#{path}:1:17: '{' is not preceded with whitespace.", errors.join(" ")
    assert_equal errors.size, $CHILD_STATUS.exitstatus
  end
end
