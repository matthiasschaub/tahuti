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

document.body.addEventListener("htmx:responseError", function (evt) {
  console.error("Unexpected htmx error", evt.detail);
  if (evt.detail.xhr) {
    if (evt.detail.xhr.status === 500) {
      alert("500 - Internal Server Error");
    } else {
      alert(event.detail.xhr.response);
    }
  } else {
    // Unspecified failure, usually caused by network error
    alert(
      "Unexpected error, check your connection and try to refresh the page.",
    );
  }
});

export { gid, eid, gid_eid };
