import htmx from "htmx.org";
import Mustache from "mustache";
import currency from "currency.js";
import Currency from "@tadashi/currency";

// extract group ID from URL
//
function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
}

htmx.defineExtension("client-side-formats", {
  transformResponse: function (text, xhr, elt) {
    function intlCurrencyFormat(cents, currency) {
      const locale =
        navigator.languages && navigator.languages.length
          ? navigator.languages[0]
          : navigator.language;
      const options = { style: "currency", currency: currency };
      const numberFormat = new Intl.NumberFormat(locale, options);
      const parts = numberFormat.formatToParts(cents);
      const fraction = parts.find((p) => p.type === "fraction");
      let precision = 0;
      if (fraction !== undefined) {
        precision = fraction.value.length;
      }
      const dollars = cents.toFixed(precision) / Math.pow(10, precision);
      return numberFormat.format(dollars);
    }

    var data = JSON.parse(text);

    switch (elt.id) {
      case "expenses": {
        for (let i = 0; i < data.length; i++) {
          const date = new Date(Number(data[i].date));
          const options = {
            month: "short",
            day: "numeric",
          };
          data[i].date = date.toLocaleDateString(undefined, options);
          const amount = data[i].amount;
          const currency = data[i].currency;
          data[i].amount = intlCurrencyFormat(amount, currency);
        }
        break;
      }

      case "details": {
        const date = new Date(Number(data.date));
        const options = {
          hour: "2-digit",
          minute: "2-digit",
        };
        data.date = date.toLocaleDateString();
        data.time = date.toLocaleTimeString([], options);

        const amount = data.amount;
        const currency = data.currency;
        data.amount = intlCurrencyFormat(amount, currency);
        break;
      }

      case "balances":
      case "reimbursements": {
        for (let i = 0; i < data.length; i++) {
          const amount = data[i].amount;
          const currency = data[i].currency;
          data[i].amount = intlCurrencyFormat(amount, currency);
        }
        break;
      }

      case "invites": {
        console.log(data);
        if (data.length > 0) {
          data = { invites: [true] };
        } else {
          data = { invites: [] };
        }
        break;
      }
    }
    return JSON.stringify(data);
  },
});

export { gid };

window.htmx = htmx;
window.Mustache = Mustache;
window.currency = currency;
window.Currency = Currency;
window.gid = gid;
