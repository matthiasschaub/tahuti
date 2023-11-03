const groupTitle = document.getElementById("group-title");

groupTitle.addEventListener("input", (event) => {
    if (groupTitle != "foo") {
        groupTitle.setCustomValidity("Please enter the value foo");
    } else {
        groupTitle.setCustomValidity("");
    }
});
