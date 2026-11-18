{ lib, pkgs, ... }:

{
  options.custom-packages.vfio-isolate = lib.mkOption {
    description = "VFIO CPU Isolation Tool";
    type = lib.types.package;
  };

  # NOTE:
  # Version found from the pypi page
  #
  # SEE:
  # https://pypi.org/project/vfio-isolate/#vfio-isolate-0.5.2.tar.gz
  config.custom-packages.vfio-isolate = with pkgs.python314Packages; buildPythonPackage rec {
    pname = "vfio-isolate";
    version = "0.5.2";
    pyproject = true;
    doCheck = false;
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-+61RHYriS0QjNB26LaHEkXE4IYTFmAEzoBPYKuiVOlo=";
    };

    build-system = [ setuptools ];
    dependencies = [
      click
      psutil
    ];
  };
}
