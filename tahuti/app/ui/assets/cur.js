// ES import
console.log("hello world");

const { dinero, toDecimal, toSnapshot } = window.dinero.js;
const { USD, EUR } = window["@dinero.js/currencies"];

const price = dinero({ amount: 1000, currency: USD });

function intlFormat(dineroObject, locale, options = {}) {
  function transformer({ value, currency }) {
    return Number(value).toLocaleString(locale, {
      ...options,
      style: "currency",
      currency: currency.code,
    });
  }

  return toDecimal(dineroObject, transformer);
}

function dineroFromFloat({ amount: float, currency, scale }) {
  const factor = currency.base ** currency.exponent || scale;
  const amount = Math.round(float * factor);

  return dinero({ amount, currency, scale });
}

console.log(intlFormat(price, "en-US")); // "$10.00"
console.log(intlFormat(price, "fr-CA")); // "10,00 $ US"
console.log(intlFormat(price, "de-DE")); // "10,00 $ US"

const host = "api.frankfurter.app";
fetch(`https://${host}/latest?amount=${toDecimal(price)}&from=GBP&to=USD`)
  .then((resp) => resp.json())
  .then((data) => {
    console.log(data);
    const result = dineroFromFloat({ amount: data.rates.USD, currency: USD });
    console.log(toDecimal(price));
    console.log(data.rates.USD);
    console.log(toSnapshot(result).amount);
    console.log(intlFormat(result, "de-DE")); // "10,00 $ US"
  });
