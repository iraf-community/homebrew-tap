class IrafMscred < Formula
  desc "Mosaic CCD reduction package"
  homepage "https://github.com/iraf-community/iraf-mscred"
  url "https://github.com/iraf-community/iraf-mscred.git", revision: "244319d"
  version "5.05+20250915"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  IRAF_PACKAGE = "mscred".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-mscred-5.05+20250915"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34de9ba4eaa5d008d0561c80ba530789ee83dfad6bf91c3bf96d216c0185607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4161955f23d5c87212cef3955df38919f01c905dc591116b1710e5525e32625a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53713a84c8d06496d0187337ac06ee41af2e4fe51eddb946c55c02183c435311"
    sha256 cellar: :any_skip_relocation, sequoia:       "d6c995b8d57accaa6f162555e91070fc4575580b3948fdde5d427c7b10b3e975"
  end

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE
    system "irafcl", "-c", "softools; mkhelpdb helpdir=lib$root.hd helpdb=lib$helpdb.mip"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/IRAF_PACKAGE).install Dir["*"]
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{lib}/iraf/extern/#{IRAF_PACKAGE}/#{IRAF_PACKAGE}.par  | cut -d\\\" -f2")
    ver = shell_output("irafcl -c #{IRAF_PACKAGE} -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end
