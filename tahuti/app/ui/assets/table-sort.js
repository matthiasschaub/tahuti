// TableSort 10.11 vom 18. 7. 2023
// JÃ¼rgen Berkemeier
// www.j-berkemeier.de
// Das Script steht unter des Lizenz: CC BY-SA 4.0 (Namensnennung - Weitergabe unter gleichen Bedingungen 4.0 International)

const tableSort = function () {
    "use strict";

    console.info("TableSort 10.11 vom 18. 7. 2023");

    const JB_tableSort = function (tab, startsort) {
        const initTableHead = function (col) {
            // Kopfzeile vorbereiten
            if (cells_in_thead[col].className.search("sortier") < 0) {
                return false;
            }
            if (cells_in_thead[col].classList.contains("sortierbar-")) {
                firstsort[col] = "desc";
            } else if (
                cells_in_thead[col].classList.contains("sortierbar") ||
                cells_in_thead[col].classList.contains("sortierbar+")
            ) {
                firstsort[col] = "asc";
            }
            const sortbutton = document.createElement("button");
            sortbutton.innerHTML =
                "<span class='visually-hidden'>" +
                sort_hint.asc +
                "</span>" +
                "<span class='visually-hidden'>" +
                sort_hint.desc +
                "</span>" +
                cells_in_thead[col].innerHTML;
            sortbutton.className = "sortbutton";
            sortbutton.type = "button";
            let sortsymbol = null;
            const symbolspan = sortbutton.querySelectorAll("span");
            if (symbolspan && symbolspan.length) {
                for (let i = 0; i < symbolspan.length; i++) {
                    if (!symbolspan[i].hasChildNodes()) {
                        sortsymbol = symbolspan[i];
                        break;
                    }
                }
            }
            if (!sortsymbol) {
                sortsymbol = document.createElement("span");
                sortbutton.appendChild(sortsymbol);
            }
            sortsymbol.classList.add("sortsymbol");
            sortsymbol.innerHTML = sortsymbol_svg;
            if (cells_in_thead[col].classList.contains("vorsortiert-")) {
                sortbutton.classList.add("sorteddesc");
                sorted = col;
            } else if (
                cells_in_thead[col].classList.contains("vorsortiert") ||
                cells_in_thead[col].classList.contains("vorsortiert+")
            ) {
                sortbutton.classList.add("sortedasc");
                sorted = col;
            } else {
                sortbutton.classList.add("unsorted");
            }
            if (cells_in_thead[col].classList.contains("sortiere-")) {
                startsort_d = col;
            } else if (
                cells_in_thead[col].classList.contains("sortiere") ||
                cells_in_thead[col].classList.contains("sortiere+")
            ) {
                startsort_u = col;
            }
            sortbutton.addEventListener(
                "click",
                function (e) {
                    if (e.detail <= 1) tsort(col);
                },
                false
            );
            cells_in_thead[col].innerHTML =
                "<span class='visually-hidden'>" +
                cells_in_thead[col].innerHTML +
                "</span>";
            cells_in_thead[col].appendChild(sortbutton);
            cells_in_thead[col].abbr = "";
            sortsymbols[col] = sortsymbol;
            sortbuttons[col] = sortbutton;
            return true;
        }; // initTableHead

        // Datum trimmen
        const trmdat = function (dmy) {
            if (dmy[0] < 10) dmy[0] = "0" + dmy[0];
            if (dmy[1] < 10) dmy[1] = "0" + dmy[1];
            if (dmy[2] < 10) dmy[2] = "200" + dmy[2];
            else if (dmy[2] < 30) dmy[2] = "20" + dmy[2];
            else if (dmy[2] < 99) dmy[2] = "19" + dmy[2];
            else if (dmy[2] > 9999) dmy[2] = "9999";
            return dmy;
        }; // trmdat

        // Tabellenzellen auslesen
        const getData = function (ele) {
            let val, sort_key;
            // Tabellenfelder auslesen
            if ((sort_key = ele.getAttribute("data-sort_key"))) val = sort_key;
            else if ((sort_key = ele.getAttribute("sort_key"))) val = sort_key;
            else val = ele.textContent;
            return val;
        }; // getData

        // Werte in etwas sortierbares umwandeln
        const convertData = function (val, col) {
            let dmy, tval, dp, msec;
            // Zahl
            if (sorttype[col] == "n") {
                // auf Datum/Zeit prÃ¼fen
                tval = val.replace(",", " "); // Falls die Zeit durch ein "," vom Datum getrennt ist.
                if (
                    !tval.search(
                        /^\s*\d+\s*\.\s*\d+\s*\.\s*\d+\s+\d+:\d\d\:\d\d\s*$/
                    )
                ) {
                    // dd. mm. yyyy hh:mm:ss
                    dp = tval.search(":");
                    dmy = tval.substring(0, dp - 2).split(".");
                    dmy[3] = tval.substring(dp - 2, dp);
                    dmy[4] = tval.substring(dp + 1, dp + 3);
                    dmy[5] = tval.substring(dp + 4, dp + 6);
                    for (let i = 0; i < 6; i++) dmy[i] = parseInt(dmy[i], 10);
                    dmy = trmdat(dmy);
                    for (let i = 3; i < 6; i++)
                        if (dmy[i] < 10) dmy[i] = "0" + dmy[i];
                    if (debugmodus)
                        console.log(val + ": dd. mm. yyyy hh:mm:ss");
                    msec = Date.parse(
                        dmy[2] +
                            "-" +
                            dmy[1] +
                            "-" +
                            dmy[0] +
                            "T" +
                            dmy[3] +
                            ":" +
                            dmy[4] +
                            ":" +
                            dmy[5]
                    );
                    if (!isNaN(msec)) return msec;
                }
                if (
                    !tval.search(/^\s*\d+\s*\.\s*\d+\s*\.\s*\d+\s+\d+:\d\d\s*$/)
                ) {
                    // dd. mm. yyyy hh:mm
                    dp = tval.search(":");
                    dmy = tval.substring(0, dp - 2).split(".");
                    dmy[3] = tval.substring(dp - 2, dp);
                    dmy[4] = tval.substring(dp + 1, dp + 3);
                    for (let i = 0; i < 5; i++) dmy[i] = parseInt(dmy[i], 10);
                    dmy = trmdat(dmy);
                    for (let i = 3; i < 5; i++)
                        if (dmy[i] < 10) dmy[i] = "0" + dmy[i];
                    if (debugmodus) console.log(val + ": dd. mm. yyyy hh:mm");
                    msec = Date.parse(
                        dmy[2] +
                            "-" +
                            dmy[1] +
                            "-" +
                            dmy[0] +
                            "T" +
                            dmy[3] +
                            ":" +
                            dmy[4] +
                            ":00"
                    );
                    if (!isNaN(msec)) return msec;
                }
                if (!tval.search(/^\s*\d+\s*\.\s*\d+\s*\.\s*\d+/)) {
                    // dd. mm. yyyy
                    dmy = tval.split(".");
                    for (let i = 0; i < 3; i++) dmy[i] = parseInt(dmy[i], 10);
                    dmy = trmdat(dmy);
                    if (debugmodus) console.log(val + ": dd. mm. yyyy");
                    msec = Date.parse(dmy[2] + "-" + dmy[1] + "-" + dmy[0]);
                    if (!isNaN(msec)) return msec;
                }
                if (!tval.search(/^\s*\d+:\d\d\:\d\d\s*$/)) {
                    // hh:mm:ss
                    dmy = tval.split(":");
                    for (let i = 0; i < 3; i++) dmy[i] = parseInt(dmy[i], 10);
                    for (let i = 0; i < 3; i++)
                        if (dmy[i] < 10) dmy[i] = "0" + dmy[i];
                    if (debugmodus) console.log(val + ": hh:mm:ss");
                    msec = Date.parse(
                        "1970-01-01T" + dmy[0] + ":" + dmy[1] + ":" + dmy[2]
                    );
                    if (!isNaN(msec)) return msec;
                }
                if (!tval.search(/^\s*\d+:\d\d\s*$/)) {
                    // hh:mm
                    dmy = tval.split(":");
                    for (let i = 0; i < 2; i++) dmy[i] = parseInt(dmy[i], 10);
                    for (let i = 0; i < 2; i++)
                        if (dmy[i] < 10) dmy[i] = "0" + dmy[i];
                    if (debugmodus) console.log(val + ": hh:mm");
                    msec = Date.parse(
                        "1970-01-01T" + dmy[0] + ":" + dmy[1] + ":00"
                    );
                    if (!isNaN(msec)) return msec;
                }
                if (
                    !val.search(/^\s*\d\d\d\d-\d\d-\d\d/) ||
                    !val.search(/^\s*\d+\/\d+\/\d\d\d\d/)
                ) {
                    // yyyy-mm-dd oder m/d/yyyy
                    msec = Date.parse(val);
                    if (!isNaN(msec)) {
                        if (debugmodus) console.log(val + ": Date.parse");
                        return msec;
                    }
                }

                // Tausendertrenner entfernen, und , durch . ersetzen, und auf Zahl prÃ¼fen
                if (!decimalpoint) {
                    tval = val.replace(/\s|Â´|'|\./g, "").replace(",", ".");
                    if (!isNaN(tval) && tval.search(/[0-9]/) != -1) {
                        if (debugmodus)
                            console.log(
                                val + ", " + tval + ": Zahl mit Dezimalkomma"
                            );
                        return tval; // Zahl
                    }
                    // Einheiten etc. entfernen und dann auf Zahl prÃ¼fen
                    tval = parseFloat(tval);
                    if (!isNaN(tval)) {
                        if (debugmodus)
                            console.log(
                                val + ", " + tval + ": Zahl mit Einheit"
                            );
                        return tval;
                    }
                } else {
                    tval = val.replace(/\s|\,/g, "");
                    if (!isNaN(tval) && tval.search(/[0-9]/) != -1) {
                        if (debugmodus)
                            console.log(
                                val + ", " + tval + ": Zahl mit Dezimalpunkt"
                            );
                        return tval; // Zahl
                    }
                    // Einheiten etc. entfernen und dann auf Zahl prÃ¼fen
                    tval = parseFloat(tval);
                    if (!isNaN(tval)) {
                        if (debugmodus)
                            console.log(
                                val + ", " + tval + ": Zahl mit Einheit"
                            );
                        return tval;
                    }
                }
            }

            // String
            sorttype[col] = "s";
            if (debugmodus) console.log(val + ": String");
            return val;
        }; // convertData

        // Vergleichsfunktion fÃ¼r Strings
        const vglFkt_s = function (a, b) {
            let ret = a[sorted].localeCompare(b[sorted], doclang);
            if (!ret && sorted != minsort) {
                if (sorttype[minsort] == "s")
                    ret = a[minsort].localeCompare(b[minsort], doclang);
                else ret = a[minsort] - b[minsort];
            }
            return ret;
        }; // vglFkt_s

        // Vergleichsfunktion fÃ¼r Zahlen
        const vglFkt_n = function (a, b) {
            let ret = a[sorted] - b[sorted];
            if (!ret && sorted != minsort) {
                if (sorttype[minsort] == "s")
                    ret = a[minsort].localeCompare(b[minsort], doclang);
                else ret = a[minsort] - b[minsort];
            }
            return ret;
        }; // vglFkt_n

        // Der Sortierer
        const tsort = (this.tsort = function (col) {
            // Event feuern
            fireevent(tab, presort, col);

            if (debugmodus) console.log(tab, col, sorttype[col]);

            if (col == sorted) {
                // Tabelle ist schon nach dieser Spalte sortiert, also nur Reihenfolge umdrehen
                arr.reverse();
                sortbuttons[col].classList.toggle("sortedasc");
                sortbuttons[col].classList.toggle("sorteddesc");
                cells_in_thead[col].abbr =
                    cells_in_thead[col].abbr == sort_info.asc
                        ? sort_info.desc
                        : sort_info.asc;
            } else {
                // Sortieren
                if (sorted > -1) {
                    sortbuttons[sorted].classList.remove("sortedasc");
                    sortbuttons[sorted].classList.remove("sorteddesc");
                    sortbuttons[sorted].classList.add("unsorted");
                    cells_in_thead[sorted].abbr = "";
                }
                sorted = col;
                sortbuttons[col].classList.remove("unsorted");
                if (sorttype[col] == "n") arr.sort(vglFkt_n);
                else arr.sort(vglFkt_s);
                if (firstsort[col] == "desc") {
                    arr.reverse();
                    sortbuttons[col].classList.add("sorteddesc");
                    cells_in_thead[col].abbr = sort_info.desc;
                } else {
                    sortbuttons[col].classList.add("sortedasc");
                    cells_in_thead[col].abbr = sort_info.asc;
                }
            }

            // Sortierte Daten zurÃ¼ckschreiben
            for (let r = 0; r < nrows; r++) tbdy.appendChild(arr[r][ncols]);

            // Aktuelle Sortierung speichern
            if (savesort) {
                let store = {
                    sorted: sorted,
                    desc: sortsymbols[sorted].classList.contains("sorteddesc"),
                };
                localStorage.setItem(tab.id, JSON.stringify(store));
            }

            // Event feuern
            fireevent(tab, aftersort, col);
        }); // tsort

        // Tabelle(n) zum Sortieren vorbereiten

        // Event feuern
        fireevent(tab, presortinit, -1);

        // Debugmodus?
        const debugmodus =
            location.search.toLowerCase().search("debugmodus") != -1;

        // Tabelle auf rowspan prÃ¼fen
        const elemente_mit_rowspan = tab.querySelectorAll("[rowspan]");
        if (elemente_mit_rowspan.length > 0) {
            for (let ele = 0; ele < elemente_mit_rowspan.length; ele++) {
                if (elemente_mit_rowspan[ele].getAttribute("rowspan") > 1) {
                    console.error(
                        "Element mit rowspan>1 gefunden!",
                        elemente_mit_rowspan[ele]
                    );
                    console.error("rowspan>1 wird nicht unterstÃ¼tzt!");
                    return null;
                }
            }
        }

        // Dokumentensprache ermitteln
        let doclang = document.documentElement.lang || "de";
        if (doclang.search("de") > -1) doclang = "de"; // auch z.B. de-ch
        if (debugmodus) console.log("doclang: " + doclang);

        // Zahlendarstellung
        const decimalpoint = tab.classList.contains("dezimalpunkt");
        if (debugmodus)
            console.log(decimalpoint ? "Decimalpoint" : "Dezimalkomma");

        // Tabellenelemente ermitteln
        const thead = tab.tHead;
        let tr_in_thead, cells_in_thead;
        if (thead) {
            tr_in_thead = thead.querySelectorAll("tr.sortierbar");
            if (!tr_in_thead.length) tr_in_thead = thead.rows;
        }
        if (tr_in_thead) cells_in_thead = tr_in_thead[0].cells;
        if (!(cells_in_thead && cells_in_thead.length > 0)) {
            console.error(
                "Tabelle hat keinen Kopf (thead) und/oder keine Kopfzellen."
            );
            return null;
        }
        let tbdy = tab.tBodies;
        if (!tbdy) {
            console.error("Tabelle hat keinen tbody.");
            return null;
        }
        tbdy = tbdy[0];
        const tr = tbdy.rows;
        if (!(tr && tr.length > 0)) {
            console.error("Tabelle hat keine Zeilen im tbody.");
            return null;
        }
        const nrows = tr.length;
        const ncols = cells_in_thead.length;

        // Einige Variablen
        let arr = [];
        let sorted = -1;
        let sortsymbols = [];
        let sortbuttons = [];
        let sorttype = [];
        let firstsort = [];
        let startsort_u = -1,
            startsort_d = -1;
        let savesort =
            tab.classList.contains("savesort") &&
            tab.id &&
            tab.id.length > 0 &&
            localStorage &&
            location.protocol != "file:";
        let minsort = -1;

        // Hinweistexte
        let sort_info, sort_hint;
        if (doclang == "de") {
            sort_info = {
                asc: "Tabelle ist aufsteigend nach dieser Spalte sortiert",
                desc: "Tabelle ist absteigend nach dieser Spalte sortiert",
            };
            sort_hint = {
                asc: "Sortiere aufsteigend nach ",
                desc: "Sortiere absteigend nach ",
            };
        } else {
            sort_info = {
                asc: "Table is sorted by this column in ascending order",
                desc: "Table is sorted by this column in descending order",
            };
            sort_hint = {
                asc: "Sort ascending by ",
                desc: "Sort descending by ",
            };
        }

        // Sortiersymbol
        const sortsymbol_svg =
            '<svg role="img" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="-5 -5 190 110"><path  d="M0 0 L50 100 L100 0 Z" style="stroke:currentColor;fill:transparent;stroke-width:10;"/><path d="M80 100 L180 100 L130 0 Z" style="stroke:currentColor;fill:transparent;stroke-width:10;"/></svg>';

        // Stylesheets fÃ¼r Button im TH
        if (!document.getElementById("JB_stylesheet_tableSort")) {
            const sortbuttonStyle = document.createElement("style");
            sortbuttonStyle.id = "JB_stylesheet_tableSort";
            const stylestring =
                ".sortbutton { width: 100%; height: 100%; border: 1px solid transparent; background-color: transparent; font: inherit; color: inherit; text-align: inherit; padding: 0; cursor: pointer; } " +
                "table.sortierbar thead th span.visually-hidden, table[sortable] thead th span.visually-hidden { position: absolute !important; clip: rect(1px, 1px, 1px, 1px) !important; padding: 0 !important; border: 0 !important; height: 1px !important; width: 1px !important; overflow: hidden !important; white-space: nowrap !important; } " +
                ".sortsymbol svg { margin-left: .2em; height: .7em; } " +
                ".sortbutton.sortedasc .sortsymbol svg path:last-of-type { fill: currentColor !important; } " +
                ".sortbutton.sorteddesc .sortsymbol svg path:first-of-type { fill: currentColor!important; } " +
                ".sortbutton.sortedasc > span.visually-hidden:nth-of-type(1) { display: none } " +
                ".sortbutton.sorteddesc > span.visually-hidden:nth-of-type(2) { display: none } " +
                ".sortbutton.unsorted > span.visually-hidden:nth-of-type(2) { display: none } " +
                "table.sortierbar caption span{ font-weight: normal; font-size: .8em; } ";
            sortbuttonStyle.innerText = stylestring;
            document.head.appendChild(sortbuttonStyle);
        }

        // PrÃ¼fen, ob kein tr im thead eine entsprechnde Klasse hat
        let sortflag = false;
        for (let c = 0; c < cells_in_thead.length; c++)
            sortflag |= cells_in_thead[c].className.search("sortier") >= 0;
        // Wenn nicht, alle Spalten sortierbar machen
        if (!sortflag)
            for (let c = 0; c < cells_in_thead.length; c++)
                cells_in_thead[c].classList.add("sortierbar");

        // Kopfzeile vorbereiten
        for (let c = cells_in_thead.length - 1; c >= 0; c--)
            if (initTableHead(c)) minsort = c;

        // Array mit Info, wie Spalte zu sortieren ist, vorbelegen
        for (let c = 0; c < ncols; c++) sorttype[c] = "n";

        // Tabelleninhalt in ein Array kopieren
        for (let r = 0; r < nrows; r++) {
            arr[r] = [];
            let all_colspan = 0;
            for (let c = 0; c < ncols; c++) {
                let colspan = 0;
                let cell = tr[r].cells[c - all_colspan];
                if (cell) {
                    if (cell.hasAttribute("colspan")) {
                        colspan = Number(cell.getAttribute("colspan"));
                    }
                    arr[r][c] = convertData(getData(cell), c);
                    if (colspan > 1) {
                        let cc;
                        for (cc = c + 1; cc < c + colspan && cc < ncols; cc++) {
                            arr[r][cc] = arr[r][c];
                        }
                        c = cc - 1;
                        all_colspan += colspan - 1;
                    }
                } else {
                    console.error(
                        "Tabellenfeld " +
                            r +
                            "," +
                            c +
                            ' nicht gefunden, Wert auf "" gesetzt!'
                    );
                    arr[r][c] = "";
                }
            }
            arr[r][ncols] = tr[r];
        }

        // Tabellenfelder, die als String sortiert werden sollen, in Strings konvertieren,
        // eventuelle Ã„nderungen rÃ¼ckgÃ¤ngig machen
        for (let r = 0; r < nrows; r++) {
            let all_colspan = 0;
            for (let c = 0; c < ncols; c++) {
                let colspan = 0;
                let cell = tr[r].cells[c - all_colspan];
                if (cell) {
                    if (cell.hasAttribute("colspan")) {
                        colspan = Number(cell.getAttribute("colspan"));
                    }
                    if (sorttype[c] == "s") {
                        arr[r][c] = String(getData(cell), c);
                    }
                    if (colspan > 1) {
                        let cc;
                        for (cc = c + 1; cc < c + colspan && cc < ncols; cc++) {
                            if (sorttype[c] == "s") arr[r][cc] = arr[r][c];
                        }
                        c = cc - 1;
                        all_colspan += colspan - 1;
                    }
                }
            }
        }

        // Im Debugmodus Tabelle ausgeben
        if (debugmodus) {
            console.log(sorttype);
            console.log(arr);
        }

        // Tabelle die Klasse "is_sortable" geben
        tab.classList.add("is_sortable");

        // An caption Hinweis anhÃ¤ngen
        const caption = tab.caption;
        if (caption)
            caption.innerHTML +=
                doclang == "de"
                    ? "<br><span>Ein Klick auf die SpaltenÃ¼berschrift sortiert die Tabelle.</span>"
                    : "<br><span>A click on the column header sorts the table.</span>";

        // Bei Bedarf sortieren
        if (
            startsort &&
            typeof startsort.sorted != "undefined" &&
            typeof startsort.desc != "undefined"
        ) {
            if (startsort.desc) {
                startsort_d = startsort.sorted;
                startsort_u = -1;
            } else {
                startsort_u = startsort.sorted;
                startsort_d = -1;
            }
        }
        if (startsort_u >= 0 && startsort_u < ncols) tsort(startsort_u);
        if (startsort_d >= 0 && startsort_d < ncols) {
            tsort(startsort_d);
            tsort(startsort_d);
        }

        // Event feuern
        fireevent(tab, aftersortinit, -1);
    }; // tableSort

    // autostart-Parameter prÃ¼fen
    let autostart = false;
    let scr = document.getElementsByTagName("script");
    for (let i = scr.length - 1; i >= 0; i--)
        if (scr[i].src && scr[i].src.length) {
            if (scr[i].src.search("TableSort.js") > -1) {
                autostart = !(scr[i].src.search(/auto.*=false/) > -1);
                break;
            }
        }

    // Sort-Events anlegen
    let eventparameter = { sortcol: -1 };
    const presortinit = new CustomEvent("presortinit", {
        detail: eventparameter,
    });
    const aftersortinit = new CustomEvent("aftersortinit", {
        detail: eventparameter,
    });
    const presort = new CustomEvent("presort", { detail: eventparameter });
    const aftersort = new CustomEvent("aftersort", { detail: eventparameter });
    const fireevent = function (tab, evt, sortcol) {
        eventparameter.sortcol = sortcol;
        tab.dispatchEvent(evt);
    }; // fireevent

    // Load-Event anlegen
    const TableSortLoaded = new CustomEvent("TableSortLoaded", {
        detail: { tableSort: JB_tableSort },
    });
    window.dispatchEvent(TableSortLoaded);

    if (autostart) {
        let initSort = function () {
            // Alle Tabellen suchen, die sortiert werden sollen, und den Tabellensortierer starten, wenn gewÃ¼nscht, alte Sortierung wiederherstellen.
            const sort_Table = document.querySelectorAll(
                "table.sortierbar, table[sortable]"
            );
            for (let i = 0, store; i < sort_Table.length; i++) {
                // PrÃ¼fen, ob Tabelle schon sortierbar ist
                if (!sort_Table[i].classList.contains("is_sortable")) {
                    store = null;
                    if (
                        location.protocol != "file:" &&
                        localStorage &&
                        sort_Table[i].id &&
                        sort_Table[i].classList.contains("savesort") &&
                        sort_Table[i].id.length
                    ) {
                        store = localStorage.getItem(sort_Table[i].id);
                        if (store) {
                            store = JSON.parse(store);
                        }
                    }
                    new JB_tableSort(sort_Table[i], store);
                }
            }
        };
        if (document.readyState == "loading")
            window.addEventListener("DOMContentLoaded", initSort, false);
        else initSort();
    } // autostart
};
