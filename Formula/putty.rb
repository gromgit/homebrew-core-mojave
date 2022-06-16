class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.77/putty-0.77.tar.gz"
  sha256 "419a76f45238fd45f2c76b42438993056e74fa78374f136052aaa843085beae5"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/putty"
    sha256 cellar: :any_skip_relocation, mojave: "5ec4e4eae331a20c2c55e3eac96b2eb2988b02a735e8b9b8e6964bbb4773b8e3"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "perl" => :build
  uses_from_macos "expect" => :test

  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    build_version = build.head? ? "svn-#{version}" : version

    args = std_cmake_args + %W[
      -DRELEASE=#{build_version}
      -DPUTTY_GTK_VERSION=NONE
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/env expect
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert_predicate testpath/"test.key", :exist?
  end
end
