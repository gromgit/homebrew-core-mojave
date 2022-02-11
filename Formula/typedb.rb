class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.6.3/typedb-all-mac-2.6.3.zip"
  sha256 "10d280a01dc8548d744cf9c51c0e3186cb68064c598fd834ef10ab02ea3b61bc"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d27600620393ae9e06f08ebdb5dc4d8bae65aa7343707aa72afbe9ae285fa25b"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
