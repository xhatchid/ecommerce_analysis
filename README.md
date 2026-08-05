# Olist Late Delivery & Customer Satisfaction Analysis

**Business question:** Which product categories and regions drive the most
late deliveries, and how does that relate to customer review scores?

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/olistbr/brazilian-ecommerce)
— ~100k real orders (2016–2018) from the largest department store on
Brazilian marketplaces.

## Tools used

- **SQL (SQLite)** — schema design, table loading, and the core joins/aggregations
  that answer the business question (`sql`)
- **Python (pandas, scipy)** — statistical testing (correlation, t-test) and
  clean CSV exports for reporting (`python`)
- **Google Sheets** — final dashboard/visuals for a non-technical audience
  (link: https://docs.google.com/spreadsheets/d/19xQQIomQe8O_7MpIAQalmQ0nV_1oybNxbFekBpe60ZI/edit?usp=sharing)


## Key findings

- **Late deliveries tank satisfaction.** Orders delivered after the estimated
  date average a **2.55–2.57** review score, vs **4.21–4.29** for on-time
  orders — a statistically significant relationship (point-biserial
  r = -0.364, p ≈ 0).
- **Lateness is heavily regional.** Northeastern states (AL, MA, SE, CE, PI,
  BA) have late-delivery rates of 15–26%, roughly 3-4x higher than the
  best-performing states — pointing to logistics/carrier issues rather than
  demand-side problems.
- **Category effects are smaller but real.** Categories like
  `christmas_supplies`, `furniture_mattress_and_upholstery`, and
  `office_furniture` show above-average lateness (~12-14%), often tied to
  bulky items or seasonal demand spikes.

## Next steps

- Segment by seller (are specific sellers driving the regional lateness?)
- Control for order value / freight distance as confounders
