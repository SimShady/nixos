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
    inherit version;
    pname = "scikit-network";
    hash = "sha256-9/fMAutCZ7Fqk4P2RiYVLlm6Q11td7GjVmW2/BvPVy0=";
  };

  # can be removed if https://github.com/sknetwork-team/scikit-network/pull/581 is merged
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "__builtins__.__NUMPY_SETUP__ = False" "__builtins__['__NUMPY_SETUP__'] = False"
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

  # meta = {
  #   description = "Free software library in Python for machine learning on graphs";
  #   changelog = "https://raw.githubusercontent.com/sknetwork-team/scikit-network/master/HISTORY.rst";
  #   homepage = "https://scikit-network.readthedocs.io";
  #   license = lib.licenses.bsd3;
  #   maintainers = with maintainers; [ simonbabovic ];
  # };
}