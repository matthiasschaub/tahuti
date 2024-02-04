// extract group ID from URL
//
function gid() {
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
  if (event.detail.elt.id === "expense") {
    // request expense
    const site = `/apps/tahuti/api/groups/${gid()}/expenses/${eid()}${
      event.detail.path
    }`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
  } else if (event.detail.elt.id === "delete-expense") {
    // delete expense
    const site = `/apps/tahuti/api/groups/${gid()}/expenses/${eid()}${
      event.detail.path
    }`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
  } else {
    // request group
    const site = `/apps/tahuti/api/groups/${gid()}${event.detail.path}`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
  }
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
