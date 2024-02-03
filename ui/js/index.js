import 'htmx.org';
import 'mustache';
import * as currency from 'currency.js';

function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
};

export {
    gid,
};

window.htmx = require('htmx.org');
window.Mustache = require('mustache');
window.currency = require('currency.js');
window.gid = gid;
