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
    const USD = (value) =>
      currency(value, {
        symbol: "$",
        pattern: `# !`,
        negativePattern: `-# !`,
        fromCents: true,
      });
    const EUR = (value) =>
      currency(value, {
        symbol: "€",
        decimal: ",",
        separator: ".",
        pattern: `# !`,
        negativePattern: `-# !`,
        fromCents: true,
      });
    const BTC = (value) =>
      currency(value, {
        symbol: "₿",
        decimal: ".",
        pattern: `# !`,
        negativePattern: `-# !`,
        fromCents: true,
        precision: 8,
      });
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

          if (currency == "EUR") {
            data[i].amount = EUR(amount).format();
          } else if (currency == "USD") {
            data[i].amount = USD(amount).format();
          } else if (currency == "BTC") {
            data[i].amount = BTC(amount).format();
          } else {
            throw "Currency code not suppored: " + currency;
          }
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

        if (currency == "EUR") {
          data.amount = EUR(amount).format();
        } else if (currency == "USD") {
          data.amount = USD(amount).format();
        } else if (currency == "BTC") {
          data.amount = BTC(amount).format();
        } else {
          throw "Currency code not suppored: " + currency;
        }
        break;
      }
      case "balances":
      case "reimbursements": {
        for (let i = 0; i < data.length; i++) {
          const currency = "EUR";
          const amount = data[i].amount;
          if (currency == "EUR") {
            data[i].amount = EUR(amount).format();
          } else if (currency == "USD") {
            data[i].amount = USD(amount).format();
          } else if (currency == "BTC") {
            data[i].amount = BTC(amount).format();
          } else {
            throw "Currency code not suppored: " + currency;
          }
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
