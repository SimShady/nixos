_: super:

{
  custom-python.scikit-network = super.callPackage ./scikit-network super.python311Packages;
  custom-python.qiskit = super.callPackage ./qiskit super.python311Packages;
}
