class Griffon < Formula
  desc "Application framework for desktop applications in the JVM"
  homepage "http://griffon-framework.org/"
  url "https://dl.bintray.com/content/aalmiray/Griffon/griffon-1.5.0-bin.tgz"
  sha256 "3f7868e8d86f10e4a5a9139661465a0b89f2646ef93a553b9bdfb625356ef876"

  disable! date: "2021-04-01", because: :unsupported

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable GRIFFON_HOME to:
        #{libexec}
    EOS
  end

  test do
    system "#{bin}/griffon", "--version"
  end
end
