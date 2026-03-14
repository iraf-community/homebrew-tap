class IrafMscred < Formula
  desc "Mosaic CCD reduction package"
  homepage "https://github.com/iraf-community/iraf-mscred"
  url "https://github.com/iraf-community/iraf-mscred.git", revision: "244319d"
  version "5.05+20250915"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-mscred-5.05+20250915"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b581736cbc5ba889d5c950b1e420976d396a159ae1bc67ad1b5c81f007c42b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a04c9826c4d2aef9b9759af36aa5c43ad124213d8b72178f318a28d8dbfa7ac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb39f845991670fdf067a3e2162c32b455202c9e0ca9fd948ba353046093c174"
    sha256 cellar: :any_skip_relocation, tahoe:         "1858329d4493944072398d3f64a698d22667c26e0f923afe27bd7ec286efac05"
    sha256 cellar: :any_skip_relocation, sequoia:       "069f768b2e6b3d980dec958d9565a7ea9e1e847caa03fcc45180ce1c9def15a1"
  end

  IRAF_PACKAGE = "mscred".freeze

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
