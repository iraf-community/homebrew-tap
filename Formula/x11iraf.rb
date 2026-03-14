class X11iraf < Formula
  desc "X11 support for IRAF"
  homepage "https://iraf-community.github.io/x11iraf"
  url "https://github.com/iraf-community/x11iraf/archive/refs/tags/v2.2.tar.gz"
  sha256 "f5c6e0b56a1f68e8c15a766d8521ec47176c4f4cb3d38e48f142dd0261746f91"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/x11iraf-2.2"
    rebuild 6
    sha256 cellar: :any, arm64_tahoe:   "280dbfe0fc2dd5e8355cffdf709fad0e703fecc905fd6e32c2f7e7ed93996c29"
    sha256 cellar: :any, arm64_sequoia: "e4b1f8ef932393f7de939281695a53dd5ca8a8bdeee885a0fea3be5a50a47f96"
    sha256 cellar: :any, arm64_sonoma:  "d5edc6e1e8ca9e746997ea3551810fb7eef66eb4c785bbb81be958cf30aecabc"
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
