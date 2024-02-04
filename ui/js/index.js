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

// extract expense ID from URL
//
function eid() {
  const parts = window.location.href.split("/");
  return parts.pop() || parts.pop(); // handle potential trailing slash
}

export { gid, eid };

window.htmx = require("htmx.org");
window.Mustache = require("mustache");
window.currency = require("currency.js");
window.gid = gid;
window.eid = eid;
