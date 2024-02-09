import * as esbuild from "esbuild";

let ctx = await esbuild.context({
  entryPoints: [
    "manifest.json",
    "./html/about.html",
    "./html/add.html",
    "./html/balances.html",
    "./html/create.html",
    "./html/details.html",
    "./html/expenses.html",
    "./html/groups.html",
    "./html/invite.html",
    "./html/invites.html",
    "./html/reimbursements.html",
    "./html/settings.html",
    "./css/style.css",
    "./css/print.css",
    "./svg/circles.svg",
    "./js/index.js",
    "./js/groups.js",
    "./js/expenses.js",
    "./node_modules/htmx.org/dist/ext/path-deps.js",
    "./node_modules/htmx.org/dist/ext/json-enc.js",
    "./node_modules/htmx.org/dist/ext/client-side-templates.js",
  ],
  entryNames: "[ext]/[name]", // will name the result files by their folder names
  bundle: true,
  minify: true,
  loader: { ".json": "copy", ".html": "copy", ".svg": "copy" },
  outdir: "../tahuti/app/ui",
});

await ctx.watch();
console.log("watching...");
