class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://github.com/mistydemeo/launch_socket_server/archive/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  license "MIT"
  head "https://github.com/mistydemeo/launch_socket_server.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/launch_socket_server"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "908804735af02dcef91612ed4f606a489b915fd97f6bc3922cf66e2f4792c382"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/launch_socket_server</string>
            <string>-</string>
          </array>
          <key>Sockets</key>
          <dict>
            <key>Socket</key>
            <dict>
              <key>SockNodeName</key>
              <string>0.0.0.0</string>
              <key>SockServiceName</key>
              <string>80</string>
            </dict>
          </dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
            <string>127.0.0.1:8080</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_includes shell_output("#{opt_sbin}/launch_socket_server 2>&1; true"),
      "usage: #{opt_sbin}/launch_socket_server"
  end
end
