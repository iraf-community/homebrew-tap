class IrafMscred < Formula
  desc "Mosaic CCD reduction package"
  homepage "https://github.com/iraf-community/iraf-mscred"
  url "https://github.com/iraf-community/iraf-mscred.git", revision: "244319d"
  version "5.05+20250915"
  sha256 "1e447c7e0cab3b41be4dbf3e390c7f94095d7b3dd1390269f1c80733d8512c7d"

  IRAF_PACKAGE = "mscred".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-mscred-5.05+20250915"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ae6e44f756339b167f7ae7c86a1e4eb75a6d1a6b740832176ea5c59b8cfb4fc0"
    sha256 cellar: :any_skip_relocation, sequoia:     "0f6589435bd9560fec0662d08b60032485fb72b4f3fd7550f6886591b480f5c6"
  end

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE

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
