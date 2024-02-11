// extract group ID from URL
//
function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
}
// extract group ID from URL with expense ID
//
function gid_eid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  parts.pop() || parts.pop();
  return parts.pop() || parts.pop();
}
// extract expense ID from URL
//
function eid() {
  const parts = window.location.href.split("/");
  return parts.pop() || parts.pop(); // handle potential trailing slash
}

// change HTMX request URL to make requests to the API
//
document.body.addEventListener("htmx:configRequest", (event) => {
  // TODO: if path starts with /apps/tahuti its an absolute path. Do not
  // change
  let path = event.detail.path;

  if (path.includes("{gid}")) {
    path = path.replace("{gid}", gid());
  }
  if (path.includes("{gid_eid}")) {
    path = path.replace("{gid_eid}", gid_eid());
  }
  if (path.includes("{eid}")) {
    path = path.replace("{eid}", eid());
  }
  if (path.includes("/apps/tahuti")) {
    path = path.replace("/apps/tahuti", "");
  }

  const site = `/apps/tahuti${path}`;
  event.detail.path = site.replace(/\/$/, ""); // without trailing slash
});

const btnInvite = document.getElementById("btn-invite");
if (btnInvite != null) {
  btnInvite.action = `/groups/${gid()}/invite`;
}

export { gid, eid, gid_eid };
