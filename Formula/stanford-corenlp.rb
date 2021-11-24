class StanfordCorenlp < Formula
  desc "Java suite of core NLP tools"
  homepage "https://stanfordnlp.github.io/CoreNLP/"
  url "https://nlp.stanford.edu/software/stanford-corenlp-4.3.2.zip"
  sha256 "2432016930c0180f31eb411d6d64757fe11720d9fedef437b346d8ae2bb9c630"
  license "GPL-2.0-or-later"

  # The first-party website only links to an unversioned archive file from
  # nlp.stanford.edu (stanford-corenlp-latest.zip), so we match the version
  # in the Maven link instead.
  livecheck do
    url :homepage
    regex(%r{href=.*?/stanford-corenlp/v?(\d+(?:\.\d+)+)/jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e02517aab8c6cf1a2de00f0ff9ae17c88f33237ae556706d35e3edc36d411cec"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"test.txt").write("Stanford is a university, founded in 1891.")
    system "#{bin}/corenlp.sh", "-annotators tokenize,ssplit,pos", "-file test.txt", "-outputFormat json"
    assert_predicate (testpath/"test.txt.json"), :exist?
  end
end
