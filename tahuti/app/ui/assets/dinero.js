/**
 * Skipped minification because the original files appears to be already minified.
 * Original file: /npm/dinero.js@2.0.0-alpha.14/dist/umd/index.production.js
 *
 * Do NOT use SRI with dynamically generated files! More information: https://www.jsdelivr.com/using-sri-with-dynamic-files
 */
/*! dinero.js 2.0.0-alpha.14 (UNRELEASED 1320a09) | MIT License | © Sarah Dayan and contributors | https://v2.dinerojs.com */
!(function (r, n) {
  "object" == typeof exports && "undefined" != typeof module
    ? n(exports)
    : "function" == typeof define && define.amd
    ? define(["exports"], n)
    : n(
        (((r =
          "undefined" != typeof globalThis ? globalThis : r || self).dinero =
          r.dinero || {}),
        (r.dinero.js = {}))
      );
})(this, function (r) {
  "use strict";
  var n,
    t = "Ratios are invalid.",
    e = "Objects must have the same currency.",
    o = "Currency is not decimal.";
  function u(r, n) {
    if (!r) throw new Error("[Dinero.js] ".concat(n));
  }
  function a(r) {
    var n = r.calculator,
      t = r.onCreate,
      e = r.formatter,
      o = void 0 === e ? { toNumber: Number, toString: String } : e;
    return function r(e) {
      var u = e.amount,
        a = e.currency,
        c = a.code,
        i = a.base,
        l = a.exponent,
        f = e.scale,
        y = void 0 === f ? l : f,
        v = { code: c, base: i, exponent: l };
      return (
        null == t || t({ amount: u, currency: v, scale: y }),
        {
          calculator: n,
          formatter: o,
          create: r,
          toJSON: function () {
            return { amount: u, currency: v, scale: y };
          },
        }
      );
    };
  }
  function c(r) {
    return function (t, e) {
      return r.compare(t, e) === n.EQ;
    };
  }
  function i(r) {
    return function (t, e) {
      return r.compare(t, e) === n.LT;
    };
  }
  function l(r) {
    var n = c(r),
      t = i(r),
      e = r.zero();
    return function (o) {
      if (n(o, e)) return e;
      if (t(o, e)) {
        var u = r.decrement(e);
        return r.multiply(u, o);
      }
      return o;
    };
  }
  function f(r) {
    return Array.isArray(r);
  }
  function y(r) {
    return function (n) {
      return f(n)
        ? n.reduce(function (n, t) {
            return r.multiply(n, t);
          })
        : n;
    };
  }
  function v(r) {
    return function (t, e) {
      return r.compare(t, e) === n.GT;
    };
  }
  function m(r) {
    return function (n, t) {
      return v(r)(n, t) || c(r)(n, t);
    };
  }
  function s(r) {
    return function (n, t) {
      var e = c(r),
        o = v(r),
        u = i(r),
        a = m(r),
        l = r.zero(),
        f = r.increment(l),
        y = t.reduce(function (n, t) {
          return r.add(n, t);
        }, l);
      if (e(y, l)) return t;
      for (
        var s = n,
          d = t.map(function (t) {
            var e = r.integerDivide(r.multiply(n, t), y) || l;
            return (s = r.subtract(s, e)), e;
          }),
          h = a(n, l),
          p = h ? o : u,
          b = h ? f : r.decrement(l),
          g = 0;
        p(s, l);

      )
        e(t[g], l) || ((d[g] = r.add(d[g], b)), (s = r.subtract(s, b))), g++;
      return d;
    };
  }
  function d(r, n) {
    var t, e;
    return (null == (e = r) ? void 0 : e.hasOwnProperty("amount"))
      ? {
          amount: r.amount,
          scale:
            null !== (t = null == r ? void 0 : r.scale) && void 0 !== t ? t : n,
        }
      : { amount: r, scale: n };
  }
  function h(r) {
    return (
      (function (r) {
        if (Array.isArray(r)) return p(r);
      })(r) ||
      (function (r) {
        if (
          ("undefined" != typeof Symbol && null != r[Symbol.iterator]) ||
          null != r["@@iterator"]
        )
          return Array.from(r);
      })(r) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return p(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return p(r, n);
      })(r) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function p(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function b(r) {
    var n = c(r),
      t = r.zero(),
      e = r.increment(r.increment(t));
    return function (o) {
      return n(r.modulo(o, e), t);
    };
  }
  function g(r) {
    var n = c(r),
      t = l(r);
    return function (e, o) {
      var u = t(r.modulo(e, o)),
        a = r.subtract(o, u);
      return n(a, u);
    };
  }
  function A(r) {
    var n = i(r);
    return function (r) {
      return r.reduce(function (r, t) {
        return n(r, t) ? t : r;
      });
    };
  }
  function w(r) {
    var n = c(r),
      t = i(r),
      e = r.zero();
    return function (o) {
      if (n(o, e)) return e;
      var u = r.increment(e),
        a = r.decrement(e);
      return t(o, e) ? a : u;
    };
  }
  function S(r) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r) {
        if (
          ("undefined" != typeof Symbol && null != r[Symbol.iterator]) ||
          null != r["@@iterator"]
        )
          return Array.from(r);
      })(r) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return O(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return O(r, n);
      })(r) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function O(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function j(r) {
    var n = S(r),
      t = n[0],
      e = n.slice(1),
      o = y(t.calculator),
      u = t.toJSON().currency,
      a = c(t.calculator),
      i = o(u.base);
    return e.every(function (r) {
      var n = r.toJSON().currency,
        t = o(n.base);
      return n.code === u.code && a(t, i) && a(n.exponent, u.exponent);
    });
  }
  !(function (r) {
    (r[(r.LT = -1)] = "LT"), (r[(r.EQ = 0)] = "EQ"), (r[(r.GT = 1)] = "GT");
  })(n || (n = {}));
  var I = function (r, n, t) {
      var e = v(t),
        o = c(t),
        u = t.zero(),
        a = e(r, u),
        i = t.integerDivide(r, n),
        l = o(t.modulo(r, n), u);
      return a || l ? i : t.decrement(i);
    },
    N = function (r, n, t) {
      var e = v(t),
        o = g(t),
        u = l(t),
        a = t.zero(),
        c = u(t.modulo(r, n)),
        i = e(t.subtract(n, c), c),
        f = e(r, a);
      return o(r, n) || (f && !i) || (!f && i) ? J(r, n, t) : I(r, n, t);
    },
    J = function (r, n, t) {
      var e = v(t),
        o = c(t),
        u = t.zero(),
        a = e(r, u),
        i = t.integerDivide(r, n);
      return !o(t.modulo(r, n), u) && a ? t.increment(i) : i;
    };
  function T(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return E(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return E(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function E(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function z(r) {
    var n = v(r),
      t = y(r);
    return function () {
      for (var e = arguments.length, o = new Array(e), u = 0; u < e; u++)
        o[u] = arguments[u];
      var a = o[0],
        c = o[1],
        i = o[2],
        l = void 0 === i ? I : i,
        f = a.toJSON(),
        y = f.amount,
        v = f.currency,
        m = f.scale,
        s = n(c, m),
        d = s ? r.multiply : l,
        h = s ? [c, m] : [m, c],
        p = T(h, 2),
        b = p[0],
        g = p[1],
        A = t(v.base),
        w = r.power(A, r.subtract(b, g));
      return a.create({ amount: d(y, w, r), currency: v, scale: c });
    };
  }
  function x(r) {
    var n = A(r),
      t = z(r),
      e = c(r);
    return function () {
      for (var o = arguments.length, u = new Array(o), a = 0; a < o; a++)
        u[a] = arguments[a];
      var c = u[0],
        i = c.reduce(function (r, t) {
          var e = t.toJSON().scale;
          return n([r, e]);
        }, r.zero());
      return c.map(function (r) {
        var n = r.toJSON().scale;
        return e(n, i) ? r : t(r, i);
      });
    };
  }
  function C(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return M(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return M(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function M(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function U(r) {
    var n = x(r),
      t = (function (r) {
        return function () {
          for (var n = arguments.length, t = new Array(n), e = 0; e < n; e++)
            t[e] = arguments[e];
          var o = t[0],
            u = t[1],
            a = o.toJSON(),
            c = a.amount,
            i = a.currency,
            l = a.scale,
            f = u.toJSON().amount,
            y = r.add(c, f);
          return o.create({ amount: y, currency: i, scale: l });
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = C(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function $(r) {
    var n = (function (r) {
        return function () {
          for (var n = arguments.length, t = new Array(n), e = 0; e < n; e++)
            t[e] = arguments[e];
          var o = t[0],
            u = t[1],
            a = o.toJSON(),
            c = a.amount,
            i = a.currency,
            l = a.scale;
          return s(r)(
            c,
            u.map(function (r) {
              return r.amount;
            })
          ).map(function (r) {
            return o.create({ amount: r, currency: i, scale: l });
          });
        };
      })(r),
      e = m(r),
      o = v(r),
      a = z(r),
      i = A(r),
      l = c(r),
      f = r.zero(),
      y = new Array(10).fill(null).reduce(r.increment, f);
    return function () {
      for (var c = arguments.length, v = new Array(c), m = 0; m < c; m++)
        v[m] = arguments[m];
      var s = v[0],
        h = v[1],
        p = h.length > 0,
        b = h.map(function (r) {
          return d(r, f);
        }),
        g = p
          ? i(
              b.map(function (r) {
                return r.scale;
              })
            )
          : f,
        A = b.map(function (n) {
          var t = n.amount,
            e = n.scale,
            o = l(e, g) ? f : r.subtract(g, e);
          return { amount: r.multiply(t, r.power(y, o)), scale: e };
        }),
        w = A.every(function (r) {
          var n = r.amount;
          return e(n, f);
        }),
        S = A.some(function (r) {
          var n = r.amount;
          return o(n, f);
        }),
        O = p && w && S;
      u(O, t);
      var j = s.toJSON(),
        I = j.scale,
        N = r.add(I, g);
      return n(a(s, N), A);
    };
  }
  function D(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return G(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return G(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function G(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function L(r) {
    var n = x(r),
      t = (function (r) {
        var n = (function (r) {
          return function (n, t) {
            return r.compare(n, t);
          };
        })(r);
        return function () {
          for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
            t[e] = arguments[e];
          var o = D(
              [t[0], t[1]].map(function (r) {
                return r.toJSON().amount;
              }),
              2
            ),
            u = o[0],
            a = o[1];
          return n(u, a);
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = D(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function Q(r) {
    var n = z(r),
      t = A(r),
      e = r.zero();
    return function () {
      for (var o = arguments.length, u = new Array(o), a = 0; a < o; a++)
        u[a] = arguments[a];
      var c = u[0],
        i = u[1],
        l = u[2],
        f = l[i.code],
        y = c.toJSON(),
        v = y.amount,
        m = y.scale,
        s = d(f, e),
        h = s.amount,
        p = s.scale,
        b = r.add(m, p);
      return n(
        c.create({ amount: r.multiply(v, h), currency: i, scale: b }),
        t([b, i.exponent])
      );
    };
  }
  function q(r) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r) {
        if (
          ("undefined" != typeof Symbol && null != r[Symbol.iterator]) ||
          null != r["@@iterator"]
        )
          return Array.from(r);
      })(r) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return P(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return P(r, n);
      })(r) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function P(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function Z(r) {
    var n = x(r),
      t = c(r);
    return function () {
      for (var r = arguments.length, e = new Array(r), o = 0; o < r; o++)
        e[o] = arguments[o];
      var u = e[0],
        a = n(u),
        c = q(a),
        i = c[0],
        l = c.slice(1),
        f = i.toJSON(),
        y = f.amount;
      return l.every(function (r) {
        var n = r.toJSON().amount;
        return t(n, y);
      });
    };
  }
  function _(r) {
    return function () {
      for (var n = arguments.length, t = new Array(n), e = 0; e < n; e++)
        t[e] = arguments[e];
      var o = t[0],
        u = t[1];
      return Z(r)([o, u]) && j([o, u]);
    };
  }
  function F(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return R(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return R(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function R(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function k(r) {
    var n = x(r),
      t = (function (r) {
        var n = v(r);
        return function () {
          for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
            t[e] = arguments[e];
          var o = F(
              [t[0], t[1]].map(function (r) {
                return r.toJSON().amount;
              }),
              2
            ),
            u = o[0],
            a = o[1];
          return n(u, a);
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = F(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function B(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return H(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return H(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function H(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function K(r) {
    var n = x(r),
      t = (function (r) {
        var n = m(r);
        return function () {
          for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
            t[e] = arguments[e];
          var o = B(
              [t[0], t[1]].map(function (r) {
                return r.toJSON().amount;
              }),
              2
            ),
            u = o[0],
            a = o[1];
          return n(u, a);
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = B(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function V(r) {
    var n = c(r),
      t = y(r);
    return function () {
      for (var e = arguments.length, o = new Array(e), u = 0; u < e; u++)
        o[u] = arguments[u];
      var a = o[0],
        c = a.toJSON(),
        i = c.amount,
        l = c.currency,
        f = c.scale,
        y = t(l.base);
      return !n(r.modulo(i, r.power(y, f)), r.zero());
    };
  }
  function W(r) {
    var n = i(r);
    return function () {
      for (var t = arguments.length, e = new Array(t), o = 0; o < t; o++)
        e[o] = arguments[o];
      var u = e[0],
        a = u.toJSON(),
        c = a.amount;
      return n(c, r.zero());
    };
  }
  function X(r) {
    var n = v(r);
    return function () {
      for (var t = arguments.length, e = new Array(t), o = 0; o < t; o++)
        e[o] = arguments[o];
      var u = e[0],
        a = u.toJSON(),
        c = a.amount;
      return n(c, r.zero());
    };
  }
  function Y(r) {
    var n = c(r);
    return function () {
      for (var t = arguments.length, e = new Array(t), o = 0; o < t; o++)
        e[o] = arguments[o];
      var u = e[0],
        a = u.toJSON(),
        c = a.amount;
      return n(c, r.zero());
    };
  }
  function rr(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return nr(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return nr(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function nr(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function tr(r) {
    var n = x(r),
      t = (function (r) {
        var n = i(r);
        return function () {
          for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
            t[e] = arguments[e];
          var o = rr(
              [t[0], t[1]].map(function (r) {
                return r.toJSON().amount;
              }),
              2
            ),
            u = o[0],
            a = o[1];
          return n(u, a);
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = rr(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function er(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return or(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return or(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function or(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function ur(r) {
    var n = (function (r) {
      return function (n, t) {
        return i(r)(n, t) || c(r)(n, t);
      };
    })(r);
    return function () {
      for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
        t[e] = arguments[e];
      var o = t[0],
        u = t[1],
        a = [o, u],
        c = a.map(function (r) {
          return r.toJSON().amount;
        }),
        i = er(c, 2),
        l = i[0],
        f = i[1];
      return n(l, f);
    };
  }
  function ar(r) {
    var n = x(r),
      t = ur(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = er(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function cr(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return ir(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return ir(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function ir(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function lr(r) {
    var n = x(r),
      t = (function (r) {
        var n = A(r);
        return function () {
          for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
            t[e] = arguments[e];
          var o = t[0],
            u = cr(o, 1)[0],
            a = u.toJSON(),
            c = a.currency,
            i = a.scale,
            l = n(
              o.map(function (r) {
                return r.toJSON().amount;
              })
            );
          return u.create({ amount: l, currency: c, scale: i });
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = j(c);
      u(i, e);
      var l = n(c);
      return t(l);
    };
  }
  function fr(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return yr(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return yr(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function yr(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function vr(r) {
    var n = (function (r) {
      var n = v(r);
      return function (r) {
        return r.reduce(function (r, t) {
          return n(r, t) ? t : r;
        });
      };
    })(r);
    return function () {
      for (var r = arguments.length, t = new Array(r), e = 0; e < r; e++)
        t[e] = arguments[e];
      var o = t[0],
        u = fr(o, 1),
        a = u[0],
        c = a.toJSON(),
        i = c.currency,
        l = c.scale,
        f = n(
          o.map(function (r) {
            return r.toJSON().amount;
          })
        );
      return a.create({ amount: f, currency: i, scale: l });
    };
  }
  function mr(r) {
    var n = x(r),
      t = vr(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = j(c);
      u(i, e);
      var l = n(c);
      return t(l);
    };
  }
  function sr(r) {
    var n = z(r),
      t = r.zero();
    return function () {
      for (var e = arguments.length, o = new Array(e), u = 0; u < e; u++)
        o[u] = arguments[u];
      var a = o[0],
        c = o[1],
        i = a.toJSON(),
        l = i.amount,
        f = i.currency,
        y = i.scale,
        v = d(c, t),
        m = v.amount,
        s = v.scale,
        h = r.add(y, s);
      return n(
        a.create({ amount: r.multiply(l, m), currency: f, scale: h }),
        h
      );
    };
  }
  function dr(r, n) {
    return (
      (function (r) {
        if (Array.isArray(r)) return r;
      })(r) ||
      (function (r, n) {
        var t =
          null == r
            ? null
            : ("undefined" != typeof Symbol && r[Symbol.iterator]) ||
              r["@@iterator"];
        if (null == t) return;
        var e,
          o,
          u = [],
          a = !0,
          c = !1;
        try {
          for (
            t = t.call(r);
            !(a = (e = t.next()).done) &&
            (u.push(e.value), !n || u.length !== n);
            a = !0
          );
        } catch (r) {
          (c = !0), (o = r);
        } finally {
          try {
            a || null == t.return || t.return();
          } finally {
            if (c) throw o;
          }
        }
        return u;
      })(r, n) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return hr(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return hr(r, n);
      })(r, n) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function hr(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function pr(r) {
    var n = x(r),
      t = (function (r) {
        return function () {
          for (var n = arguments.length, t = new Array(n), e = 0; e < n; e++)
            t[e] = arguments[e];
          var o = t[0],
            u = t[1],
            a = o.toJSON(),
            c = a.amount,
            i = a.currency,
            l = a.scale,
            f = u.toJSON().amount,
            y = r.subtract(c, f);
          return o.create({ amount: y, currency: i, scale: l });
        };
      })(r);
    return function () {
      for (var r = arguments.length, o = new Array(r), a = 0; a < r; a++)
        o[a] = arguments[a];
      var c = o[0],
        i = o[1],
        l = j([c, i]);
      u(l, e);
      var f = n([c, i]),
        y = dr(f, 2),
        v = y[0],
        m = y[1];
      return t(v, m);
    };
  }
  function br(r) {
    return (
      (function (r) {
        if (Array.isArray(r)) return gr(r);
      })(r) ||
      (function (r) {
        if (
          ("undefined" != typeof Symbol && null != r[Symbol.iterator]) ||
          null != r["@@iterator"]
        )
          return Array.from(r);
      })(r) ||
      (function (r, n) {
        if (!r) return;
        if ("string" == typeof r) return gr(r, n);
        var t = Object.prototype.toString.call(r).slice(8, -1);
        "Object" === t && r.constructor && (t = r.constructor.name);
        if ("Map" === t || "Set" === t) return Array.from(r);
        if (
          "Arguments" === t ||
          /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)
        )
          return gr(r, n);
      })(r) ||
      (function () {
        throw new TypeError(
          "Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."
        );
      })()
    );
  }
  function gr(r, n) {
    (null == n || n > r.length) && (n = r.length);
    for (var t = 0, e = new Array(n); t < n; t++) e[t] = r[t];
    return e;
  }
  function Ar(r) {
    var n = (function (r) {
      var n = r.multiply;
      return function (r) {
        return r.reduce(function (t, e, o) {
          var u = r.slice(o).reduce(function (r, t) {
            return n(r, t);
          });
          return [].concat(h(t), [u]);
        }, []);
      };
    })(r);
    return function () {
      for (var t = arguments.length, e = new Array(t), o = 0; o < t; o++)
        e[o] = arguments[o];
      var u = e[0],
        a = e[1],
        c = u.toJSON(),
        i = c.amount,
        l = c.currency,
        y = c.scale,
        v = r.power,
        m = r.integerDivide,
        s = r.modulo,
        d = f(l.base) ? l.base : [l.base],
        h = n(
          d.map(function (r) {
            return v(r, y);
          })
        ),
        p = h.reduce(
          function (r, n, t) {
            var e = r[t],
              o = m(e, n),
              u = s(e, n);
            return [].concat(
              br(
                r.filter(function (r, n) {
                  return n !== t;
                })
              ),
              [o, u]
            );
          },
          [i]
        );
      return a ? a({ value: p, currency: l }) : p;
    };
  }
  function wr(r) {
    var n = Ar(r),
      t = y(r),
      e = c(r);
    return function () {
      for (var a = arguments.length, c = new Array(a), i = 0; i < a; i++)
        c[i] = arguments[i];
      var l = c[0],
        y = c[1],
        v = l.toJSON(),
        m = v.currency,
        s = v.scale,
        d = t(m.base),
        h = r.zero(),
        p = new Array(10).fill(null).reduce(r.increment, h),
        b = f(m.base),
        g = e(r.modulo(d, p), h),
        A = !b && g;
      u(A, o);
      var w = n(l),
        S = Sr(r, l.formatter),
        O = S(w, s);
      return y ? y({ value: O, currency: m }) : O;
    };
  }
  function Sr(r, n) {
    var t = l(r),
      e = c(r),
      o = i(r),
      u = r.zero();
    return function (r, a) {
      var c = n.toString(r[0]),
        i = n.toString(t(r[1])),
        l = n.toNumber(a),
        f = "".concat(c, ".").concat(i.padStart(l, "0")),
        y = e(r[0], u),
        v = o(r[1], u);
      return y && v ? "-".concat(f) : f;
    };
  }
  function Or(r) {
    var n = (function (r) {
        var n = c(r);
        return function (t, e) {
          var o = r.zero();
          if (n(o, t)) return r.zero();
          for (var u = o, a = t; n(r.modulo(a, e), o); )
            (a = r.integerDivide(a, e)), (u = r.increment(u));
          return u;
        };
      })(r),
      t = c(r),
      e = A(r),
      o = z(r),
      u = y(r);
    return function () {
      for (var a = arguments.length, c = new Array(a), i = 0; i < a; i++)
        c[i] = arguments[i];
      var l = c[0],
        f = l.toJSON(),
        y = f.amount,
        v = f.currency,
        m = f.scale,
        s = u(v.base),
        d = n(y, s),
        h = r.subtract(m, d),
        p = e([h, v.exponent]);
      return t(p, m) ? l : o(l, p);
    };
  }
  var jr = j;
  var Ir = function (r) {
    return r.toJSON();
  };
  var Nr = a({
    calculator: {
      add: function (r, n) {
        return r + n;
      },
      compare: function (r, t) {
        return r < t ? n.LT : r > t ? n.GT : n.EQ;
      },
      decrement: function (r) {
        return r - 1;
      },
      increment: function (r) {
        return r + 1;
      },
      integerDivide: function (r, n) {
        return Math.trunc(r / n);
      },
      modulo: function (r, n) {
        return r % n;
      },
      multiply: function (r, n) {
        return r * n;
      },
      power: function (r, n) {
        return Math.pow(r, n);
      },
      subtract: function (r, n) {
        return r - n;
      },
      zero: function () {
        return 0;
      },
    },
    onCreate: function (r) {
      var n = r.amount,
        t = r.scale;
      u(Number.isInteger(n), "Amount is invalid."),
        u(Number.isInteger(t), "Scale is invalid.");
    },
  });
  (r.add = function () {
    for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
      n[t] = arguments[t];
    var e = n[0],
      o = n[1],
      u = e.calculator,
      a = U(u);
    return a(e, o);
  }),
    (r.allocate = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = $(u);
      return a(e, o);
    }),
    (r.compare = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = L(u);
      return a(e, o);
    }),
    (r.convert = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = n[2],
        a = e.calculator,
        c = Q(a);
      return c(e, o, u);
    }),
    (r.createDinero = a),
    (r.dinero = Nr),
    (r.down = I),
    (r.equal = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = _(u);
      return a(e, o);
    }),
    (r.greaterThan = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = k(u);
      return a(e, o);
    }),
    (r.greaterThanOrEqual = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = K(u);
      return a(e, o);
    }),
    (r.halfAwayFromZero = function (r, n, t) {
      var e = w(t),
        o = g(t),
        u = l(t);
      return o(r, n) ? t.multiply(e(r), J(u(r), n, t)) : N(r, n, t);
    }),
    (r.halfDown = function (r, n, t) {
      return g(t)(r, n) ? I(r, n, t) : N(r, n, t);
    }),
    (r.halfEven = function (r, n, t) {
      var e = b(t),
        o = g(t),
        u = N(r, n, t);
      return o(r, n) ? (e(u) ? u : t.decrement(u)) : u;
    }),
    (r.halfOdd = function (r, n, t) {
      var e = b(t),
        o = g(t),
        u = N(r, n, t);
      return o(r, n) && e(u) ? t.decrement(u) : u;
    }),
    (r.halfTowardsZero = function (r, n, t) {
      var e = w(t),
        o = g(t),
        u = l(t);
      return o(r, n) ? t.multiply(e(r), I(u(r), n, t)) : N(r, n, t);
    }),
    (r.halfUp = N),
    (r.hasSubUnits = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e.calculator,
        u = V(o);
      return u(e);
    }),
    (r.haveSameAmount = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e[0].calculator,
        u = Z(o);
      return u(e);
    }),
    (r.haveSameCurrency = jr),
    (r.isNegative = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e.calculator,
        u = W(o);
      return u(e);
    }),
    (r.isPositive = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e.calculator,
        u = X(o);
      return u(e);
    }),
    (r.isZero = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e.calculator,
        u = Y(o);
      return u(e);
    }),
    (r.lessThan = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = tr(u);
      return a(e, o);
    }),
    (r.lessThanOrEqual = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = ar(u);
      return a(e, o);
    }),
    (r.maximum = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e[0].calculator,
        u = lr(o);
      return u(e);
    }),
    (r.minimum = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e[0].calculator,
        u = mr(o);
      return u(e);
    }),
    (r.multiply = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = sr(u);
      return a(e, o);
    }),
    (r.normalizeScale = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e[0].calculator,
        u = x(o);
      return u(e);
    }),
    (r.subtract = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = pr(u);
      return a(e, o);
    }),
    (r.toDecimal = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = wr(u);
      return a(e, o);
    }),
    (r.toSnapshot = Ir),
    (r.toUnits = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = e.calculator,
        a = Ar(u);
      return a(e, o);
    }),
    (r.transformScale = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = n[1],
        u = n[2],
        a = e.calculator,
        c = z(a);
      return c(e, o, u);
    }),
    (r.trimScale = function () {
      for (var r = arguments.length, n = new Array(r), t = 0; t < r; t++)
        n[t] = arguments[t];
      var e = n[0],
        o = e.calculator,
        u = Or(o);
      return u(e);
    }),
    (r.up = J),
    Object.defineProperty(r, "__esModule", { value: !0 });
});
//# sourceMappingURL=index.production.js.map
