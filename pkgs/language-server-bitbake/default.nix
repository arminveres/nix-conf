# Prebuilt npm tarball ships out/server.js but no lockfile; ours is generated with
# `npm install --package-lock-only --ignore-scripts` inside the unpacked tarball.
#
# Bumping the version:
#  1. `npm pack language-server-bitbake@<ver>`, unpack it, and get the tarball hash with
#     `nix hash file --sri --type sha256 <tarball>`; set `version` and `src.hash`.
#  2. In the unpacked dir, delete `workspaces` and `scripts.prepack` from package.json (they
#     point outside the tarball), then run the lockfile command above and copy
#     package-lock.json here.
#  3. Set `npmDepsHash = lib.fakeHash` (needs `lib` in the args), build once, and paste the
#     "got:" hash. The same `del(...)` is applied to package.json again in `postPatch`.
{ buildNpmPackage, fetchurl, jq }:
buildNpmPackage rec {
  pname = "language-server-bitbake";
  version = "2.10.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-Qg3WzG/6OoH7ayIdLQ5/DnB92rKPKfsHJhqH7XL2rwo=";
  };
  sourceRoot = "package";
  postPatch = "cp ${./package-lock.json} package-lock.json\n    ${jq}/bin/jq 'del(.workspaces,.scripts.prepack)' package.json > p && mv p package.json";
  npmDepsHash = "sha256-S0ttC3cRDSoyhxBiYC2jtl9L4ByNHw3yhXbtAYhUc8Y=";
  dontNpmBuild = true;
}
