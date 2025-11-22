return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  single_file_support = true,
  root_markers = { ".git" },
  settings = {
    json = {
      schemas = {
        {
          description = "Deno config",
          fileMatch = { "deno.json", "deno.jsonc" },
          url = "https://raw.githubusercontent.com/denoland/deno/refs/heads/main/cli/schemas/config-file.v1.json",
        },
        {
          description = "NPM config",
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          description = "C/C++ compile_commands config",
          fileMatch = { "compile_commands.json" },
          url = "https://www.schemastore.org/compile-commands.json",
        },
        {
          description = "TypeScript tsconfig",
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "https://www.schemastore.org/tsconfig.json",
        },
      },
    },
    validate = { enable = true },
  },
}
