class X11iraf < Formula
  desc "X11 support for IRAF"
  homepage "https://iraf-community.github.io/x11iraf"
  url "https://github.com/iraf-community/x11iraf/archive/refs/tags/v2.2.tar.gz"
  sha256 "f5c6e0b56a1f68e8c15a766d8521ec47176c4f4cb3d38e48f142dd0261746f91"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/x11iraf-2.2"
    rebuild 5
    sha256 cellar: :any, arm64_tahoe:   "d5c3595435e72547a7b5d07d4b8bc533f9d92e5018c9cc033053467831fedb8d"
    sha256 cellar: :any, arm64_sequoia: "63a56114bdde942d8d101e952a4c25e6724bf687b6a88f50f27aa57eeb574033"
    sha256 cellar: :any, arm64_sonoma:  "5e3863471069d6059b5e81fdcea31551927aca277ceaddedb52dfb6a55eeaafc"
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
