// extract group ID from URL
//
function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
}

// change HTMX request URL to make requests to the API
//
document.body.addEventListener("htmx:configRequest", (event) => {
  // TODO: if path starts with /apps/tahuti its an absolute path. Do not
  // change
  if (
    event.detail.path === "/apps/tahuti/api/version" ||
    event.detail.path === "/apps/tahuti/api/our"
  ) {
    return;
  }
  site = `/apps/tahuti/api/groups/${gid()}${event.detail.path}`;
  event.detail.path = site.replace(/\/$/, ""); // without trailing slash
});

// set HTML href and action URLs
//
const endpoints = [
  "add",
  "expenses",
  "balances",
  "reimbursements",
  "members",
  "settings",
  "about",
  "invite",
];
for (let i = 0; i < endpoints.length; i++) {
  const element = document.getElementById(`${endpoints[i]}-href`);
  if (element != null) {
    const href = `/apps/tahuti/groups/${gid()}/${endpoints[i]}`;
    element.setAttribute("href", href);
  }
}
const btnInvite = document.getElementById("btn-invite");
if (btnInvite != null) {
  btnInvite.action = `/apps/tahuti/groups/${gid()}/invite`;
}

export {
    gid,
};