return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    local os_config
    if vim.fn.has("mac") == 1 then
      os_config = "mac"
    elseif vim.fn.has("unix") == 1 then
      os_config = "linux"
    else
      os_config = "win"
    end

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local config = {
      capabilities = capabilities,
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher,
        "-configuration", mason_path .. "/config_" .. os_config,
        "-data", workspace_dir,
      },
      root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
      settings = {
        java = {
          eclipse = { downloadSources = true },
          maven = { downloadSources = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          format = { enabled = true },
        },
      },
      init_options = {
        bundles = {},
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        jdtls.start_or_attach(config)
      end,
    })

    -- Attach to the current buffer if it's already a Java file
    if vim.bo.filetype == "java" then
      jdtls.start_or_attach(config)
    end
  end,
}
