function currentGID() {
    const parts = window.location.href.split("/");
    parts.pop() || parts.pop(); // handle potential trailing slash
    const uuid = parts.pop() || parts.pop(); // handle potential trailing slash
    return uuid;
}
const uuid = currentGID();

// change HTMX request URL to make requests to the API
//
document.body.addEventListener("htmx:configRequest", (event) => {
    site = `/apps/tahuti/api/groups/${uuid}${event.detail.path}`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
});

// set HTML href URLs
//
const endpoints = ["add", "expenses", "members"];
for (let i = 0; i < endpoints.length; i++) {
    const href = `/apps/tahuti/groups/${uuid}/${endpoints[i]}`;
    const element = document.getElementById(`${endpoints[i]}-href`);
    if (element != null) {
        element.setAttribute("href", href);
    }
}
