-- Comandos que rodam a ferramenta do subprojeto no lugar certo: pytest DENTRO da
-- imagem (precisa do env do container: Oracle client, rede) e dbt com o venv do
-- container (o `dbt` do PATH do host e Fusion 2.0 preview, engine diferente do
-- dbt-core 1.11.8 que o projeto roda).
local devcontainer = require 'utils.devcontainer'

---Raiz do repo do buffer atual, com fallback pro cwd.
local function repo_root()
  local sub = devcontainer.subproject(vim.fn.expand '%:p')
  return sub and sub.root or vim.fs.root(vim.fn.getcwd(), '.devcontainer')
end

---Imagem do compose: "<basename do repo>-<servico>". Worktree usa a dele.
local function image_for(root, service)
  return vim.fs.basename(root) .. '-' .. service .. ':latest'
end

local SUBPROJECT = 'dagster'

vim.api.nvim_create_user_command('DagsterTest', function(opts)
  local root = repo_root()
  if not root then
    vim.notify('DagsterTest: nao achei a raiz do repo (.devcontainer)', vim.log.levels.ERROR)
    return
  end
  local service = devcontainer.compose_service(root, SUBPROJECT)
  if not service then
    vim.notify('DagsterTest: sem `service` em .devcontainer/' .. SUBPROJECT .. '/devcontainer.json', vim.log.levels.ERROR)
    return
  end
  local cmd = {
    'docker',
    'run',
    '--rm',
    '-u',
    vim.uv.getuid() .. ':' .. vim.uv.getgid(),
    -- o usuario da imagem tem outro uid; com o uid do host o pytest precisa de um HOME gravavel
    '-e',
    'HOME=/tmp',
    '-e',
    'PYTHONPATH=' .. (devcontainer.container_pythonpath(root, SUBPROJECT) or ''),
    '-v',
    root .. ':/workspace',
    '-w',
    '/workspace/' .. SUBPROJECT,
    image_for(root, service),
    '.venv/bin/python',
    '-m',
    'pytest',
  }
  vim.list_extend(cmd, opts.fargs)

  vim.notify('DagsterTest: rodando pytest no container...', vim.log.levels.INFO)
  vim.system(cmd, { text = true }, function(res)
    local output = (res.stdout or '') .. (res.stderr or '')
    -- pytest reporta paths do container; o quickfix precisa dos do host
    local lines = {}
    for _, line in ipairs(vim.split((output:gsub('/workspace', root)), '\n', { trimempty = true })) do
      -- os DeprecationWarning saem como "arquivo:linha: msg" e o errorformat
      -- abaixo casaria todos eles como erro (25 entradas num run que passou)
      if not line:match 'Warning: ' then
        table.insert(lines, line)
      end
    end
    vim.schedule(function()
      vim.fn.setqflist({}, ' ', {
        title = 'DagsterTest',
        -- run que passou nao vira lista: sobra so ruido de warning que escapou do filtro
        lines = res.code == 0 and {} or lines,
        efm = '%f:%l: %m,%f:%l:%c: %m',
      })
      local level = res.code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
      vim.notify('DagsterTest: ' .. (lines[#lines] or ('exit ' .. res.code)), level)
      if res.code ~= 0 then
        vim.cmd 'copen'
      end
    end)
  end)
end, { nargs = '*', desc = 'pytest do dagster dentro do container' })

vim.api.nvim_create_user_command('DbtProject', function(opts)
  local root = repo_root()
  local site_packages = root and devcontainer.site_packages(root .. '/dbt')
  if not site_packages then
    vim.notify('DbtProject: dbt/.venv nao encontrado', vim.log.levels.ERROR)
    return
  end
  -- dbt/.env e injetado pelo compose via env_file; fora do container ninguem carrega
  local cmd = string.format(
    'set -a; . %s/dbt/.env; set +a; PYTHONPATH=%s %s %s/dbt/.venv/bin/dbt %s',
    root,
    site_packages,
    devcontainer.host_python,
    root,
    table.concat(opts.fargs, ' ')
  )
  vim.cmd('botright vsplit | terminal ' .. cmd)
end, { nargs = '*', desc = 'dbt do venv do container (dbt-core do projeto)' })
