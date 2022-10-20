class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://guichan.sourceforge.io/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/guichan/guichan-0.8.2.tar.gz"
  sha256 "eedf206eae5201eaae027b133226d0793ab9a287bfd74c5f82c7681e3684eeab"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/guichan"
    sha256 cellar: :any, mojave: "4a74eb75543f7c06332388c7a16a9afbb9277d550baf9bcb7d47795ffcace65b"
  end

  depends_on "sdl_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  resource "fixedfont.bmp" do
    url "http://guichan.sourceforge.io/oldsite/images/fixedfont.bmp"
    sha256 "fc6144c8fefa27c207560820450abb41378c705a0655f536ce33e44a5332c5cc"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    gl_lib = OS.mac? ? "-framework OpenGL" : "-lGL"
    ENV.append "CPPFLAGS", "-I#{Formula["sdl_image"].opt_include}/SDL"
    ENV.append "LDFLAGS", "-lSDL -lSDL_image #{gl_lib}"
    inreplace "src/opengl/Makefile.in", "-no-undefined", " "
    inreplace "src/sdl/Makefile.in", "-no-undefined", " "

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("fixedfont.bmp")
    (testpath/"helloworld.cpp").write <<~EOS
      #include <iostream>
      #include <guichan.hpp>
      #include <guichan/sdl.hpp>
      #include "SDL/SDL.h"

      bool running = true;

      SDL_Surface* screen;
      SDL_Event event;

      gcn::SDLInput* input;             // Input driver
      gcn::SDLGraphics* graphics;       // Graphics driver
      gcn::SDLImageLoader* imageLoader; // For loading images

      gcn::Gui* gui;            // A Gui object - binds it all together
      gcn::Container* top;      // A top container
      gcn::ImageFont* font;     // A font
      gcn::Label* label;        // And a label for the Hello World text

      void init()
      {
          SDL_Init(SDL_INIT_VIDEO);
          screen = SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE);
          SDL_EnableUNICODE(1);
          SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);

          imageLoader = new gcn::SDLImageLoader();
          gcn::Image::setImageLoader(imageLoader);
          graphics = new gcn::SDLGraphics();
          graphics->setTarget(screen);
          input = new gcn::SDLInput();

          top = new gcn::Container();
          top->setDimension(gcn::Rectangle(0, 0, 640, 480));
          gui = new gcn::Gui();
          gui->setGraphics(graphics);
          gui->setInput(input);
          gui->setTop(top);
          font = new gcn::ImageFont("fixedfont.bmp", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
          gcn::Widget::setGlobalFont(font);

          label = new gcn::Label("Hello World");
          label->setPosition(280, 220);
          top->add(label);
      }

      void halt()
      {
          delete label;
          delete font;
          delete top;
          delete gui;
          delete input;
          delete graphics;
          delete imageLoader;
      }

      void checkInput()
      {
          while(SDL_PollEvent(&event))
          {
              if (event.type == SDL_KEYDOWN)
              {
                  if (event.key.keysym.sym == SDLK_ESCAPE)
                  {
                      running = false;
                  }
                  if (event.key.keysym.sym == SDLK_f)
                  {
                      if (event.key.keysym.mod & KMOD_CTRL)
                      {
                          // Works with X11 only
                          SDL_WM_ToggleFullScreen(screen);
                      }
                  }
              }
              else if(event.type == SDL_QUIT)
              {
                  running = false;
              }
              input->pushInput(event);
          }
      }

      void run()
      {
          while(running)
          {
              checkInput();
              gui->logic();
              gui->draw();
              SDL_Flip(screen);
          }
      }

      int main(int argc, char **argv)
      {
          try
          {
               init();
              run();
              halt();
          }
          catch (gcn::Exception e)
          {
              std::cerr << e.getMessage() << std::endl;
              return 1;
          }
          catch (std::exception e)
          {
              std::cerr << "Std exception: " << e.what() << std::endl;
              return 1;
          }
          catch (...)
          {
              std::cerr << "Unknown exception" << std::endl;
              return 1;
          }
          return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/SDL",
      "-L#{Formula["sdl12-compat"].opt_lib}",
      "-L#{Formula["sdl_image"].opt_lib}",
      "-lSDL", "-lSDLmain", "-lSDL_image",
      "-L#{lib}", "-lguichan", "-lguichan_sdl"
    ]

    if OS.mac?
      flags += [
        "-framework", "Foundation",
        "-framework", "CoreGraphics",
        "-framework", "Cocoa",
        "-lobjc", "-lc++"
      ]
    else
      flags << "-lstdc++"
    end

    system ENV.cc, "helloworld.cpp", ENV.cppflags,
                   *flags, "-o", "helloworld"
    helloworld = fork do
      system testpath/"helloworld"
    end
    Process.kill("TERM", helloworld)
  end
end
