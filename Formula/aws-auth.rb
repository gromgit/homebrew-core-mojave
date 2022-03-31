require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.1.4.tgz"
  sha256 "e0d25fb35f1f1ba9e597d54f37ad2c5f16af85129542d08151e2cc01da7c3573"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aws-auth"
    sha256 cellar: :any_skip_relocation, mojave: "9d26afa60bfddbde1bb485b3760093a83c1cba8474f6517d35fb57accdead0eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn("#{bin}/aws-auth login 2>&1") do |r, w, _pid|
      r.winsize = [80, 43]
      r.gets
      sleep 1
      # switch to insert mode and add data
      w.write "Password12345678!\n"
      sleep 1
      r.gets
      w.write "Password12345678!\n"
      sleep 1
      r.gets
      output = begin
        r.gets
      rescue Errno::EIO
        nil
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "CLI configuration has no saved profiles", output
    end
  end
end
