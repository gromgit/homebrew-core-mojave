class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.5.1.tar.gz"
  sha256 "b69a76f837b6cc1c34c72ace16670360577b123ccc17872a95af07178e69fbe7"
  license "MIT"
  head "https://github.com/mholt/archiver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/archiver"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "4cab5988e7d16e97b39406d52c0000432def9bf9087b15fe60621e7da1b29792"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"arc", "cmd/arc/main.go"
  end

  test do
    output = shell_output("#{bin}/arc --help 2>&1")
    assert_match "Usage: arc {archive|unarchive", output

    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system "#{bin}/arc", "archive", "test.zip",
           "test1", "test2", "test3"

    assert_predicate testpath/"test.zip", :exist?
    assert_match "Zip archive data",
                 shell_output("file -b #{testpath}/test.zip")

    output = shell_output("#{bin}/arc ls test.zip")
    names = output.lines.map do |line|
      columns = line.split(/\s+/)
      File.basename(columns.last)
    end
    assert_match "test1 test2 test3", names.join(" ")
  end
end
