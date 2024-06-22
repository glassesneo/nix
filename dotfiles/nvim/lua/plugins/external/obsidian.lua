return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Neo Vault",
        path = [[~/Library/CloudStorage/ProtonDrive-glassesneo@protonmail.com/Neo Vault]],
      },
      {
        name = "English",
        path = [[~/Library/CloudStorage/GoogleDrive-meganeo.programmer@gmail.com/マイドライブ/study/English]],
      },
    },
    daily_notes = {
      folder = "Timestamps",
    },
    templates = {
      subdir = "template",
    },
  },
}
