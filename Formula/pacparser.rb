class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/pacparser/pacparser"
  url "https://github.com/pacparser/pacparser/archive/v1.4.0.tar.gz"
  sha256 "d62d30aa6e2b4ccdf6773fc30a8b90d1d64eb6ad8edcbf56d2b803e913dcddbb"
  license "LGPL-3.0-or-later"
  head "https://github.com/pacparser/pacparser.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pacparser"
    sha256 cellar: :any, mojave: "22fef30d2df1998d012a09ddcc4eca52cbf6c6e41b40f257a3a15749955ff7ef"
  end

  def install
    # Disable parallel build due to upstream concurrency issue.
    # https://github.com/pacparser/pacparser/issues/27
    ENV.deparallelize
    ENV["VERSION"] = version
    Dir.chdir "src"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # example pacfile taken from upstream sources
    (testpath/"test.pac").write <<~'EOS'
      function FindProxyForURL(url, host) {

        if ((isPlainHostName(host) ||
            dnsDomainIs(host, ".example.edu")) &&
            !localHostOrDomainIs(host, "www.example.edu"))
          return "plainhost/.example.edu";

        // Return externaldomain if host matches .*\.externaldomain\.example
        if (/.*\.externaldomain\.example/.test(host))
          return "externaldomain";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".google.com") &&
            isResolvable(host))
          return "isResolvable";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".notresolvabledomain.invalid") &&
            !isResolvable(host))
          return "isNotResolvable";

        if (/^https:\/\/.*$/.test(url))
          return "secureUrl";

        if (isInNet(myIpAddress(), '10.10.0.0', '255.255.0.0'))
          return '10.10.0.0';

        if ((typeof(myIpAddressEx) == "function") &&
            isInNetEx(myIpAddressEx(), '3ffe:8311:ffff/48'))
          return '3ffe:8311:ffff';

        else
          return "END-OF-SCRIPT";
      }
    EOS
    # Functional tests from upstream sources
    test_sets = [
      {
        "cmd" => "-c 3ffe:8311:ffff:1:0:0:0:0 -u http://www.example.com",
        "res" => "3ffe:8311:ffff",
      },
      {
        "cmd" => "-c 0.0.0.0 -u http://www.example.com",
        "res" => "END-OF-SCRIPT",
      },
      {
        "cmd" => "-u http://host1",
        "res" => "plainhost/.example.edu",
      },
      {
        "cmd" => "-u http://www1.example.edu",
        "res" => "plainhost/.example.edu",
      },
      {
        "cmd" => "-u http://manugarg.externaldomain.example",
        "res" => "externaldomain",
      },
      {
        "cmd" => "-u https://www.google.com",  ## internet
        "res" => "isResolvable",               ## required
      },
      {
        "cmd" => "-u https://www.notresolvabledomain.invalid",
        "res" => "isNotResolvable",
      },
      {
        "cmd" => "-u https://www.example.com",
        "res" => "secureUrl",
      },
      {
        "cmd" => "-c 10.10.100.112 -u http://www.example.com",
        "res" => "10.10.0.0",
      },
    ]
    # Loop and execute tests
    test_sets.each do |t|
      assert_equal t["res"],
        shell_output("#{bin}/pactester -p #{testpath}/test.pac " +
          t["cmd"]).strip
    end
  end
end
