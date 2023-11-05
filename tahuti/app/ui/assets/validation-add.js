const USD = (value) => currency(value); // defaults
const EUR = (value) =>
  currency(value, {
    symbol: "€",
    decimal: ",",
    separator: ".",
  });

const form = document.getElementById("put-expenses");
const amount = document.getElementById("amount");
const payer = document.getElementById("payer");
const date = document.getElementById("date");

// set defaults
//
date.valueAsDate = new Date();

// validate inputs
//
amount.addEventListener("input", (event) => {
  if (isNaN(amount.value)) {
    amount.setCustomValidity("Please enter a valid amount.");
  } else {
    amount.setCustomValidity("");
  }
});

// transform submit values
//
// send amount in cents to API
form.addEventListener("htmx:configRequest", (event) => {
  if ("amount" in event.detail.parameters) {
    event.detail.parameters.amount = USD(
      amount.value
    ).intValue.toString();
  }
  if ("date" in event.detail.parameters) {
    event.detail.parameters.date = new Date(date.value).valueOf();
  }
  console.log(event.detail.parameters.date)
});
