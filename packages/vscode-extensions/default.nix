_: super:

{
  custom-vscode-extensions.magicstack.magicpython = super.callPackage ./magicstack.magicpython super.vscode-extensions;
}

# url to generate sri hashes with
# https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage