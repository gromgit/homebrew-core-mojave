class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.85/bee-1.85.zip"
  sha256 "160dae8859fadcf454ebe5857f2af9045f9399ea8a6110403d8f34e395274708"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff2771ebea049fcf610a7b8ad173a33c1244d0f71beba80e18f6537ca1f1ffe1"
  end

  depends_on "openjdk@8"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end
