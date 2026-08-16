---
name: financial-influencer-ingestion
description: Ingest watched financial creators from X into an Obsidian vault while preserving verified raw source material, lightweight structured summaries, processing states, and a native-ID ledger. Use for scheduled daily ingestion, 7-day initial backfills, catch-up runs, retries, and Monday/Wednesday Chinese investment briefs that merge creator agreement and label disagreements. Do not use for creator ranking, prediction scoring, portfolio advice, or deep downstream analysis.
---

# Financial Influencer Ingestion

Run a deterministic, resumable, X-only ingestion workflow. Keep ingestion separate from later analysis.

## Resolve configuration

Use the vault path explicitly supplied by the user or runtime. Never hard-code a machine-specific path.

Within the vault, use:

~~~text
Financial Influencers/
├── Sources/X/
├── Digests/Daily/
├── Digests/Weekly/
└── System/
    ├── influencer-watchlist.yaml
    └── financial-influencer-ledger.json
~~~

If these files are absent, initialize them from config/influencer-watchlist.yaml and templates/financial-influencer-ledger.json. See references/architecture.md for deployment details.

## Run sequence

1. Parse and validate the watchlist and ledger. Never replace malformed state with an empty default.
2. Acquire an exclusive logical lock in active_run with a UUID, start time, and mode. Recover a lock older than six hours by recording the recovery in run_history.
3. Determine the retrieval window:
   - First successful run: previous seven calendar days in the configured timezone.
   - Daily run: enumerate watched creators and deduplicate by native ID.
   - Retry run: reconsider failed and pending_review items without discarding attempt history.
4. Process creators in watchlist order and items in ascending publication time.
5. After every attempt, atomically update and validate the ledger before moving to the next item.
6. Write a daily operations digest.
7. On Monday and Wednesday, generate the Chinese investment brief after ingestion.
8. Append run history, clear active_run, validate ledger JSON, and report counts.

Resume interrupted work from the ledger. Never recreate completed notes solely from timestamps.

## Identity and inclusion

Use x:{status_id} as the ledger key.

Include original posts, creator-authored threads, quote posts, attached images, and attached videos. Exclude pure reposts and ordinary replies. Include a creator-authored reply only when it is part of that creator's included root thread.

Store a thread as one note keyed by its root status ID. Preserve all included status IDs in component_native_ids and keep thread text in source order.

## Retrieval guardrails

Treat X as read-only. Use public pages or an already-authenticated browser session. Never:

- enter credentials or perform login;
- follow, like, repost, comment, subscribe, or message;
- change account or privacy settings;
- fabricate inaccessible text, OCR, transcript, metadata, claims, or tickers.

Preserve full verified post/thread text. Preserve quote commentary plus available quoted-post author, text, ID, and URL. Record image references and OCR when reliable. Record video references and transcripts when speech is retrievable.

When media must be downloaded for transcription, use the minimum temporary material and delete it after successful transcription. Do not commit temporary or runtime media.

## Processing states

Assign exactly one state per attempt:

- ingested: required raw content was preserved and the note write succeeded.
- skipped: confidently excluded by rule; store the reason.
- pending_review: identity, completeness, OCR, transcription, or extraction quality needs review; preserve only verified material.
- failed: a technical retrieval, parsing, transcription, or write failure prevented a usable result.

Increment attempt_count and append an attempt-history record every time. Never overwrite a complete note with an incomplete retry.

## Source notes

Write one note per native item:

~~~text
Sources/X/{creator_slug}/{published_date}--{status_id}.md
~~~

Use templates/source-note.md. Keep the structured summary above the raw source. Extract only source-supported creator thesis, claims, explicit tickers/assets, stance, catalysts, risks, and predictions.

This is traceable source-level extraction, not truth verification. Use null, empty arrays, or “未明确” rather than inference.

## Ledger

Validate against schemas/financial-influencer-ledger.schema.json when a JSON Schema validator is available. Preserve identity, timestamps, state, reason, attempt count, append-only history, note path, completeness, OCR/transcript provenance, and a content fingerprint when available.

Never remove ledger items during routine ingestion. Never mark an item ingested until its note exists.

## Monday and Wednesday brief

Run ingestion daily at 03:00 in the configured timezone. After Monday and Wednesday runs, write:

- canonical archive: Digests/Weekly/YYYY-MM-DD.md;
- current copy: Digests/投资短报-最新.md.

Use a non-overlapping window beginning immediately after the prior successful brief cutoff. If no cutoff exists, use the preceding seven calendar days. Advance the cutoff only after both files are written and verified.

Write the brief in Simplified Chinese as Markdown bullet points and keep the body within 1,000 Chinese characters. Preserve proper names, tickers, products, technical terms, and established English abbreviations.

Use [主线] for important themes; [共识] only when at least two distinct creators independently express materially equivalent views on the same topic, direction, and horizon; [分歧] for materially incompatible views; and [单一观点], [催化剂], [风险], or [预测] only when supported.

Merge repetition, name contributing creators, preserve meaningful nuance, and omit low-signal or non-investment posts. When nothing material is new, write:

- 本周无重大新增观点。

Append an operations section with window bounds, state counts, source-note links, and actionable pending/failed reasons. Do not include creator rankings, scoring, portfolio recommendations, or unsupported conclusions.

## Completion checks

Before reporting success, verify:

- every attempted ID has a ledger attempt;
- every ingested item points to an existing note;
- no pure repost or ordinary reply was ingested alone;
- source notes contain appropriate verified raw material;
- Monday/Wednesday archives use the correct non-overlapping window;
- brief body is Chinese, bullet-formatted, and at most 1,000 Chinese characters;
- every [共识] and [分歧] names its creators;
- temporary media is deleted;
- ledger JSON is valid and active_run is null.

Report partial completion honestly.
