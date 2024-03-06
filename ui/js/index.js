import htmx from "htmx.org";
import Mustache from "mustache";
import currency from "currency.js";
import Currency from "@tadashi/currency";

const locale =
  navigator.languages && navigator.languages.length
    ? navigator.languages[0]
    : navigator.language;

// extract group ID from URL
//
function gid() {
  const parts = window.location.href.split("/");
  parts.pop() || parts.pop(); // handle potential trailing slash
  return parts.pop() || parts.pop();
}

/**
 * Format a monetary amount (number) to a localized string
 * E.g. 1050 cents -> 10.50 dollar
 */
function intlCurrencyFormat(amount, currency) {
  const options = { style: "currency", currency: currency };
  const numberFormat = new Intl.NumberFormat(locale, options);
  return numberFormat.format(amount);
}

/**
 * Convert a currencies minor unit (cents) to the basic unit (dollar).
 * E.g. 1050 cents -> 10.50 dollar
 */
function centsToDollar(cents, currency) {
  const options = { style: "currency", currency: currency };
  const numberFormat = new Intl.NumberFormat(locale, options);
  const parts = numberFormat.formatToParts(cents);
  const fraction = parts.find((p) => p.type === "fraction");
  let precision = 0;
  if (fraction !== undefined) {
    precision = fraction.value.length;
  }
  return cents.toFixed(precision) / Math.pow(10, precision);
}

/**
 * Convert a currencies basic unit (dollar) to the minor unit (cents).
 * E.g. 10.50 dollar -> 1050 cents
 */
function dollarToCents(amount, currency) {
  const options = { style: "currency", currency: currency };
  const numberFormat = new Intl.NumberFormat(locale, options);
  const parts = numberFormat.formatToParts(amount);
  const fraction = parts.find((p) => p.type === "fraction");
  let precision = 0;
  if (fraction !== undefined) {
    precision = fraction.value.length;
  }
  return parseInt(amount.toFixed(precision).toString().replace(".", ""), 10);
}

htmx.defineExtension("client-side-formats", {
  transformResponse: function (text, xhr, elt) {
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

          const currency = data[i].currency;
          const amount = centsToDollar(data[i].amount, currency);
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

        const currency = data.currency;
        const amount = centsToDollar(data.amount, currency);
        data.amount = intlCurrencyFormat(amount, currency);
        break;
      }

      case "balances":
      case "reimbursements": {
        for (let i = 0; i < data.length; i++) {
          const currency = data[i].currency;
          const amount = centsToDollar(data[i].amount, currency);
          data[i].amount = intlCurrencyFormat(amount, currency);
        }
        break;
      }

      case "invites": {
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

export { gid, intlCurrencyFormat, centsToDollar, dollarToCents };

window.htmx = htmx;
window.Mustache = Mustache;
window.currency = currency;
window.Currency = Currency;
window.gid = gid;
window.intlCurrencyFormat = intlCurrencyFormat;
window.centsToDollar = centsToDollar;
window.dollarToCents = dollarToCents;
