const amount = document.getElementById("amount");
var currencyMask = Currency.data(amount);
const form = document.getElementById("put-expenses");
const currency = document.getElementById("currency");
const involves = Array.from(document.querySelectorAll(".checkbox"));
const date = document.getElementById("date");

form.addEventListener("htmx:afterSettle", (event) => {
  // values
  const groupCurrency = document.getElementById("group-currency").innerText;

  // validators
  //
  // involves: at least one checkbox (involved member) must be selected
  involves.forEach((item) => {
    item.addEventListener("click", (event) => {
      if (involves.reduce((acc, curr) => acc || curr.checked, false)) {
        // valid
        involves.at(-1).setCustomValidity("");
      } else {
        // invalid
        involves.at(-1).setCustomValidity("Select at least one.");
      }
    });
  });
  // amount: must be a number
  amount.addEventListener("input", (event) => {
    let val = currencyMask.getUnmasked();
    if (Number.isNaN(parseFloat(val)) && !Number.isFinite(val)) {
      amount.setCustomValidity("Please enter a valid amount.");
    } else {
      amount.setCustomValidity("");
    }
  });

  // defaults
  //
  // date: current date and time
  date.valueAsDate = new Date();
  // currency: group currency
  // retrieve all supported currencies and add it to select list
  const host = "api.frankfurter.app";
  // TODO: set to group currency if request fails
  fetch(`https://${host}/currencies`)
    .then((resp) => resp.json())
    .then((data) => {
      for (const [key, value] of Object.entries(data)) {
        var option = document.createElement("option");
        option.value = key;
        option.text = key;
        currency.appendChild(option);
      }
      currency.value = groupCurrency;
    });

  // input masks
  //
  // currency: use `@tadashi/currency` based on `Intl.NumberFormat`
  const userCurrency = groupCurrency;
  const userLocale =
    navigator.languages && navigator.languages.length
      ? navigator.languages[0]
      : navigator.language;
  if (currencyMask === false) {
    currencyMask = new Currency(amount, {
      maskOpts: {
        empty: true,
        locales: userLocale,
        options: {
          style: "currency",
          currency: userCurrency,
        },
      },
    });
  }

  // TODO: reload input mask (currency mask)
  currency.addEventListener("change", (event) => {
    currencyMask.opts.maskOpts.options.currency = currency.value;
    // reload masking of amount input element
    amount.dispatchEvent(new Event("input", { bubbles: true }));
  });

  // automatic conversion between currencies
  // (user selected currency to group base currency)
  //
  amount.addEventListener("input", (event) => {
    const amount = document.getElementById("amount");
    const userCurrency = document.getElementById("currency").value;
    const convertedAmount = document.getElementById("convertedAmount");
    const breakElement = document.getElementById("break");
    if (groupCurrency === userCurrency) {
      if (!convertedAmount.hasAttribute("hidden")) {
        convertedAmount.setAttribute("hidden", true);
        breakElement.setAttribute("hidden", true);
      }
      return;
    }
    const value = currencyMask.getUnmasked();
    if (value === null || value === 0) {
      return;
    }
    const host = "api.frankfurter.app";
    fetch(
      `https://${host}/latest?amount=${value}&from=${userCurrency}&to=${groupCurrency}`,
    )
      .then((resp) => resp.json())
      .then((data) => {
        convertedAmount.removeAttribute("hidden");
        breakElement.removeAttribute("hidden");
        // write as cents to data-* attribute
        convertedAmount.dataset.amount = dollarToCents(
          data.rates[groupCurrency],
          groupCurrency,
        ).toString();
        // display formatted number
        convertedAmount.innerText = `= ${intlCurrencyFormat(
          data.rates[groupCurrency],
          groupCurrency,
        )}`;
      });
  });
});

// format request values
//
form.addEventListener("htmx:configRequest", (event) => {
  // send amount in cents as string
  if ("amount" in event.detail.parameters) {
    const groupCurrency = document.getElementById("group-currency").innerText;
    const userCurrency = document.getElementById("currency").value;
    if (groupCurrency === userCurrency) {
      const amount = document.getElementById("amount");
      var val = dollarToCents(
        currencyMask.getUnmasked(),
        groupCurrency,
      ).toString();
    } else {
      var val = document.getElementById("convertedAmount").dataset.amount;
    }
    event.detail.parameters.amount = val;
    event.detail.parameters.currency = groupCurrency;
  }
  // send date as unix timestamp
  if ("date" in event.detail.parameters) {
    event.detail.parameters.date = new Date(date.value).valueOf();
  }
  // always send checkbox checks as array
  if ("involves" in event.detail.parameters) {
    if (!Array.isArray(event.detail.parameters.involves)) {
      // only one checkbox is selected
      event.detail.parameters.involves = [event.detail.parameters.involves];
    }
  }
});

form.addEventListener("htmx:afterRequest", (event) => {
  if (event.detail.successful && event.detail.elt.id == "put-expenses") {
    window.location.pathname = "/apps/tahuti/groups/" + gid() + "/expenses";
  }
});
