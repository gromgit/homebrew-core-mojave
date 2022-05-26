class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.10.0/typedb-all-mac-2.10.0.zip"
  sha256 "6e537a8f51ed1bc8f6f5ca656c956e0b6889e59f4312409e2ebc2c511778fbdd"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be8427ae1e7b2296a352b285ca016398703d5ed04a2f04882643c5d3cb273ba2"
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
