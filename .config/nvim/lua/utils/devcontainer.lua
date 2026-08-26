-- Os venvs dos subprojetos sao construidos DENTRO do devcontainer, mas caem no
-- bind mount (`.:/workspace` no docker-compose), entao o site-packages e legivel
-- do host. Ferramenta pura-python de la roda com o python3.11 do host (mesma
-- minor da imagem); o interpretador do venv NAO roda -- o symlink aponta pra
-- dentro do container.
--
-- Nada de nome de servico ou de pacote hardcoded aqui: tudo sai do
-- devcontainer.json de cada subprojeto.
local M = {}

M.host_python = 'python3.11'

local function devcontainer_json(root, name)
  local path = root .. '/.devcontainer/' .. name .. '/devcontainer.json'
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and table.concat(lines, '\n') or nil
end

---Um subprojeto por .devcontainer/<nome>/devcontainer.json. Ordem estavel (glob).
function M.subprojects(root)
  local names = {}
  for _, path in ipairs(vim.fn.glob(root .. '/.devcontainer/*/devcontainer.json', false, true)) do
    table.insert(names, vim.fs.basename(vim.fs.dirname(path)))
  end
  return names
end

---Raiz do repo e subprojeto de um path qualquer.
---@return { root: string, name: string, dir: string }|nil
function M.subproject(path)
  local root = vim.fs.root(path, '.devcontainer')
  if not root then
    return nil
  end
  local name = path:sub(#root + 2):match '^([^/]+)'
  if not name then
    return nil
  end
  return { root = root, name = name, dir = root .. '/' .. name }
end

---site-packages do venv do subprojeto, ou nil se o venv ainda nao foi criado.
function M.site_packages(dir)
  return vim.fn.glob(dir .. '/.venv/lib/python*/site-packages', false, true)[1]
end

---Servico do docker-compose que o devcontainer do subprojeto usa.
function M.compose_service(root, name)
  local json = devcontainer_json(root, name)
  return json and json:match '"service"%s*:%s*"([^"]+)"'
end

---PYTHONPATH que o devcontainer exporta, em paths do container.
function M.container_pythonpath(root, name)
  local json = devcontainer_json(root, name)
  return json and json:match '"PYTHONPATH"%s*:%s*"([^"]+)"'
end

---O mesmo PYTHONPATH traduzido pro host. Sem essas raizes o pyright nao resolve
---os imports absolutos do subprojeto.
local function host_pythonpath(root, name)
  local paths = {}
  for entry in vim.gsplit(M.container_pythonpath(root, name) or '', ':', { trimempty = true }) do
    -- entrada fora do bind mount so existe na imagem (site-packages dela)
    if entry:match '^/workspace' then
      table.insert(paths, (entry:gsub('^/workspace', root)))
    end
  end
  return paths
end

---Paths que o pyright precisa pra resolver os imports.
---O root_dir do pyright e a RAIZ DO REPO (o .git mora lá), entao um cliente
---atende todos os subprojetos: nesse caso devolve a uniao dos venvs que existem.
---Com um path dentro de um subprojeto, devolve so o dele. site-packages vem antes
---das raizes do repo, senao `import <lib>` casa com o DIRETORIO de mesmo nome.
function M.python_paths(path)
  local root = vim.fs.root(path, '.devcontainer')
  if not root then
    return {}
  end
  local scoped = path:sub(#root + 2):match '^([^/]+)'
  local paths = {}
  for _, name in ipairs(M.subprojects(root)) do
    local site_packages = (not scoped or scoped == name) and M.site_packages(root .. '/' .. name)
    if site_packages then
      table.insert(paths, site_packages)
      vim.list_extend(paths, host_pythonpath(root, name))
    end
  end
  return paths
end

---true quando o modulo esta no venv do subprojeto do arquivo.
---Serve de condition do conform: sem venv, cai no fallback do mason.
function M.has_module(path, module)
  local sub = M.subproject(path)
  local site_packages = sub and M.site_packages(sub.dir)
  return site_packages ~= nil and vim.fn.isdirectory(site_packages .. '/' .. module) == 1
end

---PYTHONPATH pro python do host achar o site-packages do venv do container.
function M.pythonpath_env(path)
  local sub = M.subproject(path)
  local site_packages = sub and M.site_packages(sub.dir)
  return site_packages and { PYTHONPATH = site_packages } or nil
end

return M
