(()=>{htmx.defineExtension("client-side-templates",{transformResponse:function(r,b,n){var i=htmx.closest(n,"[mustache-template]");if(i){var a=JSON.parse(r),t=i.getAttribute("mustache-template"),e=htmx.find("#"+t);if(e)return Mustache.render(e.innerHTML,a);throw"Unknown mustache template: "+t}var u=htmx.closest(n,"[mustache-array-template]");if(u){var a=JSON.parse(r),t=u.getAttribute("mustache-array-template"),e=htmx.find("#"+t);if(e)return Mustache.render(e.innerHTML,{data:a});throw"Unknown mustache template: "+t}var p=htmx.closest(n,"[handlebars-template]");if(p){var a=JSON.parse(r),t=p.getAttribute("handlebars-template"),l=htmx.find("#"+t).innerHTML,s=Handlebars.compile(l);if(s)return s(a);throw"Unknown handlebars template: "+t}var h=htmx.closest(n,"[handlebars-array-template]");if(h){var a=JSON.parse(r),t=h.getAttribute("handlebars-array-template"),l=htmx.find("#"+t).innerHTML,s=Handlebars.compile(l);if(s)return s(a);throw"Unknown handlebars template: "+t}var d=htmx.closest(n,"[nunjucks-template]");if(d){var a=JSON.parse(r),m=d.getAttribute("nunjucks-template"),e=htmx.find("#"+m);return e?nunjucks.renderString(e.innerHTML,a):nunjucks.render(m,a)}var c=htmx.closest(n,"[xslt-template]");if(c){var t=c.getAttribute("xslt-template"),e=htmx.find("#"+t);if(e){var f=e.innerHTML?new DOMParser().parseFromString(e.innerHTML,"application/xml"):e.contentDocument,o=new XSLTProcessor;o.importStylesheet(f);var a=new DOMParser().parseFromString(r,"application/xml"),T=o.transformToFragment(a,document);return new XMLSerializer().serializeToString(T)}else throw"Unknown XSLT template: "+t}var v=htmx.closest(n,"[nunjucks-array-template]");if(v){var a=JSON.parse(r),m=v.getAttribute("nunjucks-array-template"),e=htmx.find("#"+m);return e?nunjucks.renderString(e.innerHTML,{data:a}):nunjucks.render(m,{data:a})}return r}});})();
