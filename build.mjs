import * as esbuild from "esbuild";

let ctx = await esbuild.context({
  entryPoints: [
    "./ui/manifest.json",
    "./ui/html/about.html",
    "./ui/html/add.html",
    "./ui/html/balances.html",
    "./ui/html/create.html",
    "./ui/html/details.html",
    "./ui/html/expenses.html",
    "./ui/html/groups.html",
    "./ui/html/invite.html",
    "./ui/html/invites.html",
    "./ui/html/reimbursements.html",
    "./ui/html/settings.html",
    "./ui/css/style.css",
    "./ui/css/print.css",
    "./ui/svg/add.svg",
    "./ui/svg/circles.svg",
    "./ui/svg/tahuti.svg",
    "./ui/png/ios/16.png",
    "./ui/png/ios/64.png",
    "./ui/png/ios/180.png",
    "./ui/png/ios/192.png",
    "./ui/png/ios/512.png",
    "./ui/js/index.js",
    "./ui/js/groups.js",
    "./ui/js/add.js",
    "./node_modules/htmx.org/dist/ext/path-deps.js",
    "./node_modules/htmx.org/dist/ext/json-enc.js",
    "./node_modules/htmx.org/dist/ext/client-side-templates.js",
  ],
  entryNames: "[ext]/[name]", // will name the result files by their folder names
  bundle: true,
  minify: true,
  loader: { ".json": "copy", ".html": "copy", ".svg": "copy", ".png": "copy" },
  outdir: "tahuti/app/ui",
});

await ctx.watch();
console.log("watching...");