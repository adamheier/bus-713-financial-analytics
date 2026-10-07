# Submission Component 3 — Executive Summary

> **Hinweis:** Abgabetext auf Englisch, Fließtext ohne Frage-Überschriften (wie in Task 1).
> Version A ist die Abgabefassung (~250 Wörter) und deckt die vier geforderten Punkte für **beide**
> Fragen ab — die Rubrik verlangt ausdrücklich „drawing on findings from both questions".
> Version B ergänzt Challenges und Application.
>
> Jede Zahl stammt aus [bus713_R-code_AdamHeier2.R](bus713_R-code_AdamHeier2.R).

---

## Version A — Abgabefassung (252 Wörter)

**Executive Summary**

This report advises a portfolio manager on NVIDIA and Intel and evaluates a proposed five-year
investment project. In one reproducible R script, I estimated each stock's beta against the Nasdaq
over sixty months, applied the CAPM and the Security Market Line, measured how the two stocks move
together, forecast Intel's price six months ahead, and valued the project using NPV, IRR and a Monte
Carlo simulation.

Both stocks amplify the market almost two to one, with betas of 1.93 and 1.84. Both plot above the
Security Market Line, but only NVIDIA's outperformance is statistically significant; Intel's rests
largely on one month in which it gained 114%, and without 2026 its beta falls to 1.11. A correlation
of 0.23 makes a combined position less volatile than either stock alone, yet its beta stays at 1.89,
so market risk is not diversified away. Intel's price proved unforecastable: the best model behaves
like a random walk, with an 80% range of $68 to $212 by March 2027. The project merely returns its
$500,000 cost, giving an IRR of 0% and an NPV of −$121,000 at 10%, and it creates value in only 1.2%
of 10,000 simulations.

I recommend holding the stocks only as a satellite position weighted towards NVIDIA, protecting
Intel with put options, and rejecting the project unless its cost falls below $380,000.

The findings are limited by the CAPM's single factor, a historical window dominated by an AI boom,
a backward-looking market risk premium, and a simulation that treats each year as independent.

---

## Version B — mit Challenges und Application (415 Wörter)

**Executive Summary**

This report advises a portfolio manager on NVIDIA and Intel and evaluates a proposed five-year
investment project. In one reproducible R script, I estimated each stock's beta against the Nasdaq
over sixty months, applied the CAPM and the Security Market Line, measured how the two stocks move
together, forecast Intel's price six months ahead, and valued the project using NPV, IRR and a Monte
Carlo simulation.

Both stocks amplify the market almost two to one, with betas of 1.93 and 1.84. Both plot above the
Security Market Line, but only NVIDIA's outperformance is statistically significant; Intel's rests
largely on one month in which it gained 114%, and without 2026 its beta falls to 1.11. A correlation
of 0.23 makes a combined position less volatile than either stock alone, yet its beta stays at 1.89,
so market risk is not diversified away. Intel's price proved unforecastable: the best model behaves
like a random walk, with an 80% range of $68 to $212 by March 2027. The project merely returns its
$500,000 cost, giving an IRR of 0% and an NPV of −$121,000 at 10%, and it creates value in only 1.2%
of 10,000 simulations.

I recommend holding the stocks only as a satellite position weighted towards NVIDIA, protecting
Intel with put options rather than index futures, because three quarters of its risk is
firm-specific, and rejecting the project unless its cost falls below $380,000. The findings are
limited by the CAPM's single factor, a historical window dominated by an AI boom, a backward-looking
market risk premium, and a simulation that treats each year as independent.

The hardest part was deciding how to treat Intel's extreme 2026 rally. Removing it would have made
the statistics look cleaner but less honest, so I kept it and showed its influence instead. The
forecast raised a similar question: the data confirmed that no method reliably beats today's price,
so the useful output was the range rather than the point estimate. On the technical side, the
Federal Reserve database refused requests without an API key, so I took the ten-year Treasury yield
from Yahoo Finance instead.

The tools transfer directly to practice. Testing a forecast on data it has not seen applies to any
sales or demand projection, and a Monte Carlo simulation turns a business case from a single
optimistic number into a probability management can act on. Personally, the project result is the
lasting lesson: getting your money back is not the same as earning a return on it.

---

## Prüfhinweise vor der Abgabe

- **Wortzahl:** Version A hat 252 Wörter, Version B 415. Falls Version A gekürzt werden muss: den Halbsatz
  „and without 2026 its beta falls to 1.11" streichen (−8 Wörter).
- **Beide Fragen abgedeckt:** Die Rubrik verlangt Befunde aus Frage 1 *und* 2 — beide Versionen
  enthalten Analyse, Befund, Empfehlung und Limitation für das Aktienportfolio und das Projekt.
- **KI-Kennzeichnung ist Pflicht.** Die Aufgabenbeschreibung (AT2-PDF) verlangt: *„You must
  acknowledge the use of AI in your submission."* Eine Zeile unter der Summary genügt. Formuliere
  sie so, dass sie beschreibt, wofür du KI tatsächlich genutzt hast, z. B.:
  > *AI acknowledgement: Claude (Anthropic) was used to support structuring the R code and drafting
  > explanatory text. All analytical choices, results and conclusions were reviewed and are my own.*
- **Zahlen bei neuem Lauf prüfen:** Das Skript lädt Daten bis Ende September 2026. Läuft es mit
  verändertem Zeitraum, ändern sich alle Werte und müssen hier nachgezogen werden.
