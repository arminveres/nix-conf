local hostname = vim.loop.os_gethostname()
-- https://nix-community.github.io/nixd/md_nixd_2docs_2configuration.html
local config = {}

if hostname:match("nixos-.*") ~= nil then
	config = {
		settings = {
			options = {
				nixos = {
					expr = '(builtins.getFlake "/home/arminveres/nix-conf").nixosConfigurations.'
					    .. hostname
					    .. ".options",
				},
				home_manager = {
					-- nixos with hm module
					expr = '(builtins.getFlake "/home/arminveres/nix-conf").nixosConfigurations.'
					    .. hostname
					    .. ".options.home-manager.users.type.getSubOptions []",
					-- hm styl
					-- expr = '(builtins.getFlake "/home/arminveres/nix-conf").homeConfigurations.arminveres@' .. vim.uv.os_gethostname() .. ".options",
				},
				-- currently not used
				-- flake_parts = { expr = 'let flake = builtins.getFlake ("/home/arminveres/nix-conf"); in flake.debug.options // flake.currentSystem.options', },
			},
		},
	}
else
	-- TODO: do for hm only configs
end

vim.lsp.config("nixd", config)
