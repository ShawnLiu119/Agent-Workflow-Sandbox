# Agent Workflow Sandbox
Reusable, auditable agent workflows. This repository currently contains **Financial Influencer Ingestion V1**, an X-only workflow that preserves source material in Obsidian and produces concise Chinese investment briefs.

## Financial Influencer Ingestion V1

The workflow:

- reads an explicit creator watchlist;
- checks X daily at 03:00 in America/Chicago;
- identifies content by native X status ID and a persistent ledger;
- preserves verified post/thread text and attachment metadata;
- marks incomplete text, image OCR, or video transcription as pending_review instead of inventing content;
- creates a Chinese, bullet-point investment brief on Monday and Wednesday;
- merges equivalent views under [共识] and labels incompatible views under [分歧];
- keeps ingestion separate from ranking, scoring, portfolio advice, and deeper analysis.

## Repository layout

~~~text
skills/
└── financial-influencer-ingestion/
    ├── SKILL.md
    ├── agents/openai.yaml
    ├── config/
    │   ├── automation.yaml
    │   └── influencer-watchlist.yaml
    ├── references/architecture.md
    ├── schemas/financial-influencer-ledger.schema.json
    ├── scripts/bootstrap-vault.sh
    └── templates/
        ├── financial-influencer-ledger.json
        ├── investment-brief.md
        └── source-note.md
~~~

## Quick start

1. Review skills/financial-influencer-ingestion/config/influencer-watchlist.yaml and enable only verified X profiles.
2. Bootstrap an Obsidian vault:

   ~~~bash
   ./skills/financial-influencer-ingestion/scripts/bootstrap-vault.sh "/path/to/your/Obsidian/vault"
   ~~~

3. Set FINANCIAL_INFLUENCER_VAULT to the vault root for scheduled runs.
4. Install or invoke the skill from skills/financial-influencer-ingestion/SKILL.md.
5. Configure your scheduler from skills/financial-influencer-ingestion/config/automation.yaml.
6. Use an already-authenticated browser session when X requires authentication. The workflow never logs in or performs account actions.

## Security and privacy

This repository intentionally contains no passwords, tokens, cookies, browser profiles, session data, private Obsidian content, downloaded media, or machine-specific absolute paths. Public creator handles are configuration, not credentials.

Do not commit runtime Sources, Digests, ledgers containing collected content, temporary media, .env files, or browser/session exports. The included ledger is an empty template only.

## V1 boundaries

- Supported ingestion platform: X
- YouTube and Xiaohongshu: disabled
- Backfill: previous 7 calendar days
- Briefs: Monday and Wednesday, up to 1,000 Chinese characters
- Out of scope: creator ranking, prediction scoring, consensus weighting, portfolio recommendations, and deep historical analysis
