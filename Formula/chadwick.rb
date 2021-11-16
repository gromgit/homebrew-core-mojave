class Chadwick < Formula
  desc "Tools for parsing Retrosheet MLB play-by-play files"
  homepage "https://chadwick.sourceforge.io"
  url "https://downloads.sourceforge.net/project/chadwick/chadwick-0.7/chadwick-0.7.2/chadwick-0.7.2.tar.gz"
  sha256 "f7b3af15281106e101e2ccc4cb182a3f15dbdc3327f2bcb045bfc486a8fda46e"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/chadwick[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "38685dff8c84293981d24cb109e29e7daab5054c8b643e5d4f4345a6ca5b68ab"
    sha256 cellar: :any,                 arm64_big_sur:  "3feae6163c485d40c22f4dcbd0f2772245e8010e7beb4b9f9c399bd93d46f475"
    sha256 cellar: :any,                 monterey:       "12a233aaf2854a5ab2d7561581465d51f014f9622e2231b5e3da98f4041937be"
    sha256 cellar: :any,                 big_sur:        "d03f388d1a56550fdc5b9832bf0a952c35a5b7d38f0661885c0dc4b7ee01d718"
    sha256 cellar: :any,                 catalina:       "693c6ee0980401936a83453bdbc398aeb0eb06ba9bb8e101046508b14edfdc98"
    sha256 cellar: :any,                 mojave:         "a068fd25b1e8b3d6f9a56a8a1d4ac18a49f07f82450b1ab3f3766b86fb0a362a"
    sha256 cellar: :any,                 high_sierra:    "427b5c0fca10b23b66c56bda3537080df2ba467edea59a9dfd2f0fba56f50f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a384612258d503ddcdf39abc98c60e3cfdad289aaaad89169ee18f6f4e596639"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    date_d = 24
    date_m = 10
    date_y = 2000
    date_m_d_y = "#{date_m}/#{date_d}/#{date_y}" # chadwick's standard output
    date_xml = "#{date_y}/#{date_m}/#{date_d}" # chadwick's xml output
    date_xml_slug = date_xml.delete "/"

    # game_id and attributes for the retrosheet "team file"
    attr = { game_id: "ATL#{date_xml_slug}0", home: "ATL", home_name: "Braves",
             home_city: "Atlanta", visitor: "NYN", visitor_name: "Mets",
             visitor_city: "New York" }

    # retrosheet "event file" name, chadwick's xml name?, our value
    attr_map_info = [
      [:visteam, :visitor, attr[:visitor]], [:hometeam, :home, attr[:home]],
      [:site, :site, "ATL02"], [:date, :date, date_xml], [:number, nil, "0"],
      [:starttime, :start_time, "8:00PM"], [:daynight, :day_night, "night"],
      [:umphome, :umpire_hp, "barkl901"], [:umphp, :umpire_hp, "barkl901"],
      [:ump1b, :umpire_1b, "rippm901"], [:ump2b, :umpire_2b, "cedeg901"],
      [:ump3b, :umpire_3b, "danlk901"], [:temp, :temperature, "60"],
      [:winddir, :wind_direction, "ltor"], [:windspeed, :wind_speed, "8"],
      [:timeofgame, :time_of_game, "187"], [:attendance, :attendance, "8"]
    ]

    # expected (computed) score related data in chadwick's output
    exp_linescore = { away_runs: "1", away_hits: "1", away_errors: "0",
                      home_runs: "0", home_hits: "3", home_errors: "0" }
    exp_ing_ln_score = { away: ["0", "0", "1"], home: ["0", "0", "0"] }
    exp_innings_cnt = exp_ing_ln_score.values[0].size
    exp_tmplayers_cnt = 9 # expected player count for each team

    evn_file = testpath/"#{attr[:home]}#{date_y}.EVN" # retrosheet "event file"
    evn_file.write "id,#{attr[:game_id]}\nversion,2\n"

    evn_file.open("a") do |f| # info,...,...
      attr_map_info.each { |a, _, v| f.puts ["info", a, v].join(",") }
    end

    evn_file.append_lines <<~EOS
      start,youne003,"Eric Young",0,1,7\nstart,murpd006,"Daniel Murphy",0,2,4
      start,wrigd002,"David Wright",0,3,5\nstart,granc001,"Curtis Granderson",0,4,9
      start,dudal001,"Lucas Duda",0,5,3\nstart,lagaj001,"Juan Lagares",0,6,8
      start,darnt001,"Travis d'Arnaud",0,7,2\nstart,tejar001,"Ruben Tejada",0,8,6
      start,colob001,"Bartolo Colon",0,9,1\nstart,heywj001,"Jason Heyward",1,1,9
      start,uptob001,"B.J. Upton",1,2,8\nstart,freef001,"Freddie Freeman",1,3,3
      start,johnc003,"Chris Johnson",1,4,5\nstart,uptoj001,"Justin Upton",1,5,7
      start,uggld001,"Dan Uggla",1,6,4\nstart,gatte001,"Evan Gattis",1,7,2
      start,simma001,"Andrelton Simmons",1,8,6\nstart,haraa001,"Aaron Harang",1,9,1
      play,1,0,youne003,01,CX,S8/L\nplay,1,0,murpd006,22,C*BBS1FF1>FS,K
      play,1,0,wrigd002,00,>B,SB2\nplay,1,0,wrigd002,31,>B.FBBX,63/G
      play,1,0,granc001,11,*BCX,3/L\nplay,1,1,heywj001,22,BCFBC,K
      play,1,1,uptob001,02,SST,K\nplay,1,1,freef001,01,FX,D8/L
      play,1,1,johnc003,10,BX,9/F\nplay,2,0,dudal001,21,BBCX,2/P2F
      play,2,0,lagaj001,32,BBSBSS,K\nplay,2,0,darnt001,12,BFCX,9/F
      play,2,1,uptoj001,12,CCFBX,8/F\nplay,2,1,uggld001,32,TBFBBX,53/G
      play,2,1,gatte001,01,CX,S9/G\nplay,2,1,simma001,02,CCX,9/F
      play,3,0,tejar001,31,BBBCB,W\nplay,3,0,colob001,02,LLL,K/BF
      play,3,0,youne003,30,B1BBB,W.1-2\nplay,3,0,murpd006,01,CX,9/F.2-3
      play,3,0,wrigd002,00,>C,SB2\nplay,3,0,wrigd002,22,>C.F*B*BB,WP.3-H;2-3
      play,3,0,wrigd002,32,>C.F*B*BB.X,8/F\nplay,3,1,haraa001,02,CSS,K
      play,3,1,heywj001,31,BBBCX,7/F\nplay,3,1,uptob001,11,FBX,S7/G
      play,3,1,freef001,20,111BB1X,3/L
    EOS

    team_file = testpath/"TEAM#{date_y}" # retrosheet "team file"
    team_file.write <<~EOS
      #{attr[:home]},N,#{attr[:home_city]},#{attr[:home_name]}
      #{attr[:visitor]},N,#{attr[:visitor_city]},#{attr[:visitor_name]}
    EOS

    ros_file_h = testpath/"#{attr[:home]}#{date_y}.ROS" # retrosheet "roster"
    ros_file_h.write <<~EOS
      freef001,Freeman,Freddie,L,R,ATL,1B\ngatte001,Gattis,Evan,R,R,ATL,C
      haraa001,Harang,Aaron,R,R,ATL,P\nheywj001,Heyward,Jason,L,L,ATL,OF
      simma001,Simmons,Andrelton,R,R,ATL,SS\nuggld001,Uggla,Dan,R,R,ATL,2B
      uptob001,Upton,B.J.,R,R,ATL,OF\nuptoj001,Upton,Justin,R,R,ATL,OF
      johnc003,Johnson,Chris,R,R,ATL,3B
    EOS

    ros_file_v = testpath/"#{attr[:visitor]}#{date_y}.ROS" # retrosheet "roster"
    ros_file_v.write <<~EOS
      colob001,Colon,Bartolo,R,R,NYN,P\ndarnt001,d'Arnaud,Travis,R,R,NYN,C
      dudal001,Duda,Lucas,L,R,NYN,OF\ngranc001,Granderson,Curtis,L,R,NYN,RF
      lagaj001,Lagares,Juan,R,R,NYN,OF\nmurpd006,Murphy,Daniel,L,R,NYN,3B
      tejar001,Tejada,Ruben,R,R,NYN,SS\nwrigd002,Wright,David,R,R,NYN,3B
      youne003,Yong,Eric,B,R,NYN,OF
    EOS

    # check chadwick's standard output
    exec_str = "#{bin}/cwbox -X -q -i #{attr[:game_id]} -y #{date_y} #{evn_file}"
    out = shell_output(exec_str.sub("-X", ""))
    assert_match "Game of #{date_m_d_y} -- #{attr[:visitor_city]} at #{attr[:home_city]}", out

    # check chadwick's xml output
    out_xml = shell_output(exec_str)
    require "rexml/document"
    doc = REXML::Document.new(out_xml)
    assert root = doc.root

    # check the root attributes
    attr_map_info.each { |_, ch_at, v| assert v == root.attributes[ch_at.to_s] if ch_at }
    attr.each { |ch_at, v| assert v == root.attributes[ch_at.to_s] }

    # check the computed scores
    exp_linescore.each { |k, v| assert v == root.elements["linescore"].attributes[k.to_s] }
    assert root.elements.to_a("linescore/inning_line_score").size == exp_innings_cnt

    root.elements.to_a("linescore/inning_line_score").each_with_index do |ing_line_score, idx|
      exp_ing_ln_score.each do |k, values|
        assert ing_line_score.attributes[k.to_s] == values[idx.to_i]
      end
    end

    # check the player count and that their full names have been fetched from the roster files
    assert root.elements["players[@team='#{attr[:visitor]}']"].elements.size == exp_tmplayers_cnt
    assert root.elements["players[@team='#{attr[:home]}']"].elements.size == exp_tmplayers_cnt
    root.elements.each("players/player") do |e|
      assert (!e.attributes["fname"].empty? && !e.attributes["lname"].empty?)
    end
  end
end
