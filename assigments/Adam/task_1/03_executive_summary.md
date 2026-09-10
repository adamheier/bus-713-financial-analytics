# Submission Component 3 — Executive Summary

> **Hinweis:** Abgabetext auf Englisch, Fließtext ohne Frage-Überschriften. Version A ist die
> Fassung zum Einreichen (~250 Wörter, deckt alle vier geforderten Punkte ab). Version B ergänzt
> Challenges und Application, falls der Marker die beiden separat sehen will.
>
> Alle Zahlen stammen aus dem aktuellen [bus713_assessment1.R](bus713_assessment1.R) und sind dort
> reproduzierbar. Belege in [00_analyse_ergebnisse.md](00_analyse_ergebnisse.md).

---

## Version A — Abgabefassung (281 Wörter)

**Executive Summary**

This assessment asks whether individual large-cap technology stocks offered a better opportunity than
tracking the broader market. I compared NVIDIA and Intel with the Nasdaq Composite from January 2005
to December 2025, using one reproducible R script built on adjusted prices from Yahoo Finance and US
consumer price data from the Federal Reserve. It measures returns, volatility, downside risk and
long-run growth in both nominal and inflation-adjusted terms.

The outcomes could hardly be further apart. NVIDIA compounded at 39.2% a year and Intel at 5.0%,
against 12.0% for the index. Inflation of 2.57% a year cut all three further: in 2005 purchasing
power, ten thousand dollars invested then was worth 6.1 million in NVIDIA, 63,000 in the index and
16,000 in Intel. Both stocks were far riskier than the index, at 46% and 31% annual volatility
against 18%, but only NVIDIA was compensated for it, with a Sharpe ratio of 0.90 against 0.63 for
the index and 0.26 for Intel. Risk is also a regime rather than a constant: volatility clusters, and
Intel's Value at Risk over the last two years is two thirds worse than its twenty-one-year figure.

For an investor the index therefore belongs at the core of a portfolio and a single stock in a
deliberately sized satellite position, judged in real, risk-adjusted terms rather than on headline
returns, with risk re-estimated on a recent window.

Three limitations qualify this: NVIDIA was selected with hindsight, so the comparison shows what
stock-picking costs when it fails rather than proving that it works; historical Value at Risk
assumes the past repeats; and the Nasdaq excludes dividends while the stock series include them.

---

## Version B — mit Challenges und Application (547 Wörter)

**Executive Summary**

This report asks whether individual large-cap technology stocks offered a better opportunity than
tracking the broader market. I compared NVIDIA and Intel with the Nasdaq Composite from January 2005
to December 2025 in a single reproducible R script that pulls adjusted prices from Yahoo Finance and
US consumer price data from the Federal Reserve, and measures returns, volatility, downside risk and
long-run growth in both nominal and inflation-adjusted terms.

The outcomes could hardly be further apart. NVIDIA compounded at 39.2% a year and Intel at 5.0%,
against 12.0% for the index. After inflation of 2.57% a year, ten thousand dollars invested in 2005
was worth 6.1 million in NVIDIA, 63,000 in the index and 16,000 in Intel, all in 2005 purchasing
power. Both stocks were far riskier than the index, at 46% and 31% annual volatility against 18%,
but only NVIDIA was compensated for it, with a Sharpe ratio of 0.90 against 0.63 for the index and
0.26 for Intel; the Sortino ratio, which penalises only downside moves, gives the same ranking. On
the worst five percent of trading days, a one-million-dollar position lost 67,000 dollars on average
in NVIDIA and 50,000 in Intel, against 33,000 in the index.

Risk also proved to be a regime rather than a constant. Squared daily returns stay positively
autocorrelated beyond fifty trading days, which means turbulence persists once it begins, and
Intel's Value at Risk over the last two years is two thirds worse than its twenty-one-year figure.
A risk limit built on the long-run average would be far too small for the position held today.

For an investor this means the index belongs at the core of a portfolio, and a single stock in a
deliberately sized satellite position. Performance should be judged in real, risk-adjusted terms
rather than on headline returns, and risk re-estimated on a recent window rather than once over the
full history. Three limitations qualify this: NVIDIA was selected with hindsight, historical Value
at Risk assumes the past repeats, and the Nasdaq is a price index without dividends while the stock
series include them.

The main practical difficulty was the data rather than the statistics. The Federal Reserve endpoint
used in the module material refuses requests without an API key, so I added a fallback that reads
the public CSV series instead, and one monthly observation is missing from the source because a
government shutdown delayed its release. The harder judgement was methodological: choosing monthly
log returns for comparing performance but daily arithmetic returns for tail risk, and realising that
a single Value at Risk over twenty-one years averages across regimes that have nothing in common,
which is why I re-estimated it on recent data.

The workflow generalises well beyond finance: pull data through an API, transform it, compute a
small number of decision-relevant measures, and finish with one table and one chart a non-specialist
can act on. A script beats a spreadsheet here because it is repeatable and auditable. Personally,
the distinction between nominal and real values is the lasting takeaway — a salary or a savings
account can rise in money terms and still lose purchasing power, and only the inflation-adjusted
figure shows whether you are actually better off.

---

## Prüfhinweise vor der Abgabe

- Alle genannten Zahlen werden vom aktuellen Skript berechnet und stehen in `cagr_table`,
  `risk_summary`, `var_es`, `var_recent`, `acf_table` und `performance`. Bei einem Lauf mit
  späterem Enddatum ändern sie sich und müssen hier nachgezogen werden.
- Bewusst **nicht** verwendet: Drawdown-Zahlen und der Vergleich von Intels Kurs- gegen
  Gesamtrendite. Beides wird im aktuellen Skript nicht mehr berechnet — Aussagen ohne Codebeleg
  gehören nicht in die Zusammenfassung.
- Die Aufgabenstellung verlangt Challenges und Application zusätzlich zu den vier Fragen. Wenn nur
  eine Datei abgegeben wird, ist Version B die sichere Wahl; bei strikter 250-Wörter-Grenze
  Version A abgeben und beides im Video ansprechen.
