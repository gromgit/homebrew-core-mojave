class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.6.2/liquibase-4.6.2.tar.gz"
  sha256 "b15081de5d6e12764138663ad6cae020822f395e4a5a89dbca5801840d45f91e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0150e8c3af42f899aa484ea264205c346795711469c29b8e0967ae3bcf77746"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", JAVA_HOME: Formula["openjdk"].opt_prefix
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
