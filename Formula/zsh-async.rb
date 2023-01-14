class ZshAsync < Formula
  desc "Perform tasks asynchronously without external tools"
  homepage "https://github.com/mafredri/zsh-async"
  url "https://github.com/mafredri/zsh-async/archive/v1.8.6.tar.gz"
  sha256 "0f2778cb882b73471569b016bbfa6d9d75572bff40dc7f25ac50b3a8dc94ef47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "70f99dea8c8e873996507d7e7be083fa5ef70cc2f33e92d131c4cc0dacda4a0c"
  end

  uses_from_macos "zsh"

  def install
    zsh_function.install "async.zsh" => "async"
  end

  test do
    example = <<~ZSH
      source #{zsh_function}/async
      async_init

      # Initialize a new worker (with notify option)
      async_start_worker my_worker -n

      # Create a callback function to process results
      COMPLETED=0
      completed_callback() {
        COMPLETED=$(( COMPLETED + 1 ))
        print $@
      }

      # Register callback function for the workers completed jobs
      async_register_callback my_worker completed_callback

      # Give the worker some tasks to perform
      async_job my_worker print hello
      async_job my_worker sleep 0.3

      # Wait for the two tasks to be completed
      while (( COMPLETED < 2 )); do
        print "Waiting..."
        sleep 0.1
      done

      print "Completed $COMPLETED tasks!"
    ZSH
    assert_match "Completed 2 tasks!", shell_output("zsh -c '#{example}'")
  end
end
