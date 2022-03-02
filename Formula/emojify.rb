class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.2.tar.gz"
  sha256 "a75d49d623f92974d7852526591d5563c27b7655c20ebdd66a07b8a47dae861c"
  license "MIT"
  head "https://github.com/mrowa44/emojify.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/emojify"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "235cee647d5d302860f024f17c4a2e19f4da6fbebea8c626a96549fc17770357"
  end


  def install
    bin.install "emojify"
  end

  test do
    input = "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , "\
            "so :telephone_receiver: me, maybe?"
    assert_equal "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?",
      shell_output("#{bin}/emojify \"#{input}\"").strip
  end
end
