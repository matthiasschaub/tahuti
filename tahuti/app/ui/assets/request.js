// change HTMX request URL to make requests to the API
//
var parts = window.location.href.split("/");
parts.pop() || parts.pop();            // handle potential trailing slash
var uuid = parts.pop() || parts.pop(); // handle potential trailing slash
document.body.addEventListener("htmx:configRequest", (event) => {
    site = `/apps/tahuti/api/groups/${uuid}${event.detail.path}`;
    event.detail.path = site.replace(/\/$/, ""); // without trailing slash
});

// set HTML href URLs
//
let endpoints = ["add", "expenses", "members"];
for (let i = 0; i < endpoints.length; i++) {
    let href = `/apps/tahuti/groups/${uuid}/${endpoints[i]}`;
    let element = document.getElementById(`${endpoints[i]}-href`);
    if (element != null) {
        element.setAttribute("href", href);
    }
}
