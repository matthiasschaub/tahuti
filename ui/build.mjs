import * as esbuild from 'esbuild'

await esbuild.build({
  entryPoints: [
        './js/index.js',
        './js/groups.js',
        './js/expenses.js',
        './node_modules/htmx.org/dist/ext/path-deps.js',
        './node_modules/htmx.org/dist/ext/json-enc.js',
        './node_modules/htmx.org/dist/ext/client-side-templates.js',
        './css/style.css',
        './css/print.css',
  ],
  entryNames: "[ext]/[name]", // will name the result files by their folder names
  bundle: true,
  minify: true,
  outdir: "../tahuti/app/ui",
})
