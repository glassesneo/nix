import {
  BaseConfig,
  ContextBuilder,
  ConfigReturn,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.5/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.5/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
      extParams: {}
    });

    type Toml = {
      hooks_file?: string;
      ftplugins?: Record<string, string>;
      plugins?: Plugin[];
    };

    type LazyMakeStateResult = {
      plugins: Plugin[];
      stateLines: string[];
    };

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomlFiles = [
      { name: "colortheme.toml", lazy: true },
      { name: "bypass.toml", lazy: true },
      { name: "denops.toml", lazy: false },
      { name: "dpp.toml", lazy: false },
      { name: "depends.toml", lazy: true },
      { name: "ddc.toml", lazy: true },
      { name: "ddu.toml", lazy: false },
      { name: "editing.toml", lazy: true },
      { name: "formatter.toml", lazy: true },
      { name: "git.toml", lazy: true },
      { name: "lsp.toml", lazy: true },
      { name: "motion.toml", lazy: true },
      { name: "snippet.toml", lazy: true },
      { name: "statusline.toml", lazy: true },
      // { name: "skk.toml", lazy: true },
      { name: "treesitter.toml", lazy: true },
      { name: "ui.toml", lazy: true },
      { name: "visibility.toml", lazy: true },
    ]

    const tomlPromises = tomlFiles.map((tomlFile) =>
      args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: "$PLUGIN_DIR/" + tomlFile.name,
          options: {
            lazy: tomlFile.lazy,
          },
        },
      ) as Promise<Toml | undefined>,
    );

    const tomls: (Toml | undefined)[] = await Promise.all(tomlPromises)

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    tomls.forEach((toml) => {

      for (const plugin of toml.plugins) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    });

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult;

    return {
      plugins: lazyResult.plugins,
      stateLines: lazyResult.stateLines,
    };
  }
}
