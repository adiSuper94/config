require("nvim-tree").setup({
	hijack_cursor = true,
  view = {
    mappings = {
      list = {
        {key = {"l", "<CR>"}, action="open"},
        {key = "h", action="close"}
      }
    }
  }
})
require'nvim-web-devicons'.get_icons()
