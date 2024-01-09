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
    site = `/apps/tahuti/api/groups/${gid()}${event.detail.path}`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
});

// set HTML href and action URLs
//
const endpoints = [
    "add",
    "expenses",
    "balances",
    "members",
    "settings",
    "invite",
];
for (let i = 0; i < endpoints.length; i++) {
    const element = document.getElementById(`${endpoints[i]}-href`);
    if (element != null) {
        const href = `/apps/tahuti/groups/${gid()}/${endpoints[i]}`;
        element.setAttribute("href", href);
    }
}
document.getElementById(
    "btn-invite"
).action = `/apps/tahuti/groups/${gid()}/invite`;
