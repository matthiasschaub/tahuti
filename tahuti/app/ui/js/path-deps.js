(()=>{var d=(f,n)=>()=>(n||f((n={exports:{}}).exports,n),n.exports);var p=d(u=>{(function(f){"use strict";var n=this;function l(e,r){if(e==="ignore")return!1;for(var t=e.split("/"),a=r.split("/"),i=0;i<a.length;i++){var s=t.shift(),o=a[i];if(s!==o&&s!=="*")return!1;if(t.length===0||t.length===1&&t[0]==="")return!0}return!1}function h(e){for(var r=htmx.findAll("[path-deps]"),t=0;t<r.length;t++){var a=r[t];l(a.getAttribute("path-deps"),e)&&htmx.trigger(a,"path-deps")}}htmx.defineExtension("path-deps",{onEvent:function(e,r){if(e==="htmx:beforeOnLoad"){var t=r.detail.requestConfig;t.verb!=="get"&&r.target.getAttribute("path-deps")!=="ignore"&&h(t.path)}}}),n.PathDeps={refresh:function(e){h(e)}}}).call(u)});p();})();
