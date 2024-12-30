import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddc-vim@~9.1.0/config";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const commonSources = ["around", "rg", "file"];
    const headMatchers = ["matcher_head", "matcher_prefix"];
    const commonConverters = [
      "converter_truncate_abbr",
      "converter_remove_overlap",
    ];
    const fuzzyMatchers = ["matcher_fuzzy"];
    const fuzzySorters = ["sorter_fuzzy"];
    const fuzzyConverters = ["converter_fuzzy"].concat(commonConverters);
    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: commonSources,
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "InsertEnter",
        "CmdlineEnter",
        "CmdlineChanged",
      ],
      cmdlineSources: {
        ":": ["file", "cmdline", "cmdline-history", "around"],
        "/": commonSources,
      },
      sourceOptions: {
        _: {
          matchers: headMatchers,
          sorters: ["sorter_rank"],
          converters: commonConverters,
          minAutoCompleteLength: 3,
          ignoreCase: true,
        },
        around: {
          mark: "[around]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
          minAutoCompleteLength: 1,
        },
        buffer: {
          mark: "[buf]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
        },
        cmdline: {
          mark: "[>_]",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
          minAutoCompleteLength: 1,
        },
        "cmdline-history": {
          mark: "[>_] his",
          sorters: [],
          minAutoCompleteLength: 1,
        },
        file: {
          mark: "[file]",
          forceCompletionPattern: "S/S*",
          isVolatile: true,
        },
        line: {
          mark: "[line]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
        },
        lsp: {
          mark: "[LSP]",
          matchers: fuzzyMatchers.concat(["matcher_prefix"]),
          sorters: ["sorter_lsp-kind"],
          converters: ["converter_kind_labels"].concat(fuzzyConverters),
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        "nvim-lua": {
          mark: "[lua]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
          forceCompletionPattern: "/w*",
        },
        rg: {
          mark: "[rg]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
          minAutoCompleteLength: 6,
        },
        skkeleton: {
          mark: "[SKK]",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
          minAutoCompleteLength: 1,
        },
        treesitter: {
          mark: "[TS]",
          matchers: fuzzyMatchers,
          sorters: fuzzySorters,
          converters: fuzzyConverters,
        },
      },
      sourceParams: {
        buffer: {
          limitBytes: 5000000,
          forceCollect: true,
        },
        lsp: {
          enableAdditionalTextEdit: true,
          enableDisplayDetail: true,
          enableMatchLabel: true,
          enableResolveItem: true,
          lspEngine: "nvim-lsp",
          // wip -- consider switching to denippet.vim
          // snippetEngine: async (body: string) => {
          //   await luaeval(args.denops, `require'luasnip'.lsp_expand(${body})`);
          // },
        },
      },
      postFilters: ["postfilter_score"],
      filterParams: {
        converter_fuzzy: {
          hlGroup: "Title",
        },
        postfilter_score: {
          hlGroup: "",
        },
        converter_kind_labels: {
          kindLabels: {
            Text: "󰉿 text",
            Method: "󰆧 method",
            Function: "󰊕 function",
            Constructor: " constructor",
            Field: "󰜢 field",
            Variable: "󰀫 variable",
            Class: "󰠱 class",
            Interface: " interface",
            Module: " module",
            Property: "󰜢 property",
            Unit: "󰑭 unit",
            Value: "󰎠 value",
            Enum: " enum",
            Keyword: "󰌋 keyword",
            Snippet: " snippet",
            Color: "󰏘 color",
            File: "󰈙 file",
            Reference: "󰈇 reference",
            Folder: "󰉋 folder",
            EnumMember: " enum member",
            Constant: "󰏿 constant",
            Struct: "󰙅 struct",
            Event: " event",
            Operator: "󰆕 operator",
            TypeParameter: " type parameter",
          },
          kindHlGroups: {
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
          },
        },
      },
      uiParams: {
        "ui-pum": {
          insert: false,
        },
      },
      backspaceCompletion: true,
    });
    await Promise.resolve();
  }
}
