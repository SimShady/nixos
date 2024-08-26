{
  lib,
  vscode-utils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "magicpython";
    publisher = "magicstack";
    version = "1.1.0";
    hash = "sha256-2xr95Fne1lkvc8Zcxe7Zrl4/TB+n+ayVjjQKKbj8/CM=";
  };

  # meta = {
  #   changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-pylance/changelog";
  #   description = "Performant, feature-rich language server for Python in VS Code";
  #   downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance";
  #   homepage = "https://github.com/microsoft/pylance-release";
  #   license = lib.licenses.unfree;
  #   maintainers = [ lib.maintainers.ericthemagician ];
  # };
}