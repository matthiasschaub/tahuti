import "htmx.org";
import "mustache";
import * as currency from "currency.js";

// extract group ID from URL
//
function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
}

function loading() {
  const e = document.getElementById("overlay");
  e.classList.add("htmx-request");
}

export { gid, loading };

window.htmx = require("htmx.org");
window.Mustache = require("mustache");
window.currency = require("currency.js");
window.gid = gid;
window.eid = eid;
window.gid_eid = gid_eid;
window.loading = loading;
