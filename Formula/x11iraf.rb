class X11iraf < Formula
  desc "X11 support for IRAF"
  homepage "https://iraf-community.github.io/x11iraf"
  url "https://github.com/iraf-community/x11iraf/archive/refs/tags/v2.2.tar.gz"
  sha256 "f5c6e0b56a1f68e8c15a766d8521ec47176c4f4cb3d38e48f142dd0261746f91"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/x11iraf-2.2"
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "629753059cab20f66bd6d50a398c66cab0f14c7da64aa5593a297684f233885f"
    sha256 cellar: :any, arm64_sequoia: "fc9ca9b4f2489dfdaab5ddff76e6fe3d6565577591fe19fbc5bd44a758a9fb5e"
    sha256 cellar: :any, arm64_sonoma:  "0a56d2c537e3a2e2181d6798f9bde6532c7d6185eccb27d7c14f3c2b34c5a21b"
  end

  depends_on "iraf" => :build
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxaw3d"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  uses_from_macos "ncurses"
  uses_from_macos "tcl-tk"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    system "tic", "-v", "-o", "#{share}/terminfo", "xgterm/xgterm.terminfo"
    libexec.install bin/"xgterm"
    (bin/"xgterm").write_env_script(libexec/"xgterm", TERMINFO: "#{opt_prefix}/share/terminfo")
  end

  def caveats
    <<~EOS
      Running x11iraf locally requires to install the XQuartz server, either
      as Homebrew cask with

        brew install --cask xquartz

      or from its homepage https://www.xquartz.org/
    EOS
  end
end
