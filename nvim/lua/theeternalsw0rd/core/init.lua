require("theeternalsw0rd.core.options")
require("theeternalsw0rd.core.keymaps")
local myOS = package.config:sub(1, 1) == "\\" and "win" or "unix"
if myOS == "unix" then
	vim.env.PYENV_VERSION = vim.fn.system("pyenv version"):match("(%S+)%s+%(.-%)")
	vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/py3nvim/bin/python"
end
