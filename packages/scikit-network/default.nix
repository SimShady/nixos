{
  lib,
  buildPythonPackage,
  fetchPypi,

  cython,
  setuptools,
  numpy,
  scipy,
  pytest-runner,
  pytest,
  nose,
  pluggy,
  ...
}:
buildPythonPackage rec {
  pname = "scikit-network";
  version = "0.33.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9/fMAutCZ7Fqk4P2RiYVLlm6Q11td7GjVmW2/BvPVy0=";
  };

  # can be removed if https://github.com/sknetwork-team/scikit-network/pull/581 is merged
  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn "__builtins__.__NUMPY_SETUP__ = False" "__builtins__['__NUMPY_SETUP__'] = False"
  '';

  build-system = [
    cython
    setuptools
    numpy
    scipy
    pytest-runner
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytest
    nose
    pluggy
  ];

  pythonImportscheck = [ "sknetwork" ];

  # meta = with lib; {
  #   description = "A set of python modules for machine learning and data mining";
  #   changelog =
  #     let
  #       major = versions.major version;
  #       minor = versions.minor version;
  #       dashVer = replaceStrings [ "." ] [ "-" ] version;
  #     in
  #     "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
  #   homepage = "https://scikit-learn.org";
  #   license = licenses.bsd3;
  #   # maintainers = with maintainers; [ davhau ];
  # };
}