local hostname = vim.loop.os_gethostname() or ""
-- https://nix-community.github.io/nixd/md_nixd_2docs_2configuration.html
local flake = '(builtins.getFlake "/home/arminveres/nix-conf")'
local options = {}

if hostname:match("nixos-.*") ~= nil then
	options = {
		nixos = { expr = flake .. ".nixosConfigurations." .. hostname .. ".options" },
		-- nixos with hm module
		home_manager = {
			expr = flake .. ".nixosConfigurations." .. hostname .. ".options.home-manager.users.type.getSubOptions []",
		},
	}
else
	-- standalone home-manager (no nixosConfiguration for this host)
	options = {
		home_manager = { expr = flake .. ".homeConfigurations.ubuntu-cli.options" },
	}
end

vim.lsp.config("nixd", { settings = { nixd = { options = options } } })
