# V1 architecture

## Layers

V1 implements ingestion only:

1. Discover eligible content from the explicit X watchlist.
2. Deduplicate with native status IDs and the persistent ledger.
3. Preserve verified raw source material in Obsidian.
4. Add lightweight, traceable source-level extraction.
5. Produce daily run diagnostics.
6. Produce a Monday/Wednesday Chinese investment brief.

Creator ranking, prediction scoring, weighted consensus, historical performance analysis, and portfolio recommendations belong in separate future analysis skills.

## Runtime vault structure

~~~text
Financial Influencers/
├── Sources/
│   └── X/
├── Digests/
│   ├── Daily/
│   └── Weekly/
├── System/
│   ├── influencer-watchlist.yaml
│   └── financial-influencer-ledger.json
└── 投资短报.md
~~~

The Git repository contains configuration and empty templates. The vault contains runtime data and must not be committed.

## Security boundary

- X is read-only.
- Authentication may come only from a browser session that is already logged in.
- The workflow never stores or enters credentials.
- Login actions, account changes, engagement, and messaging are prohibited.
- Raw source text may contain sensitive or copyrighted material; keep runtime vault data private and out of this repository.

## State model

ingested means required raw material was preserved. pending_review means verified partial material exists but completeness or extraction quality remains uncertain. failed means no usable result was produced. skipped records a confident exclusion decision.

The ledger is append-oriented. Native IDs establish identity; timestamps define reporting windows but never deduplicate content.
