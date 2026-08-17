# Financial Influencer Ingestion V1

An X-only, reusable agent workflow that preserves verified financial-influencer source material in Obsidian and produces concise Chinese investment briefs.

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
.
├── README.md
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
- SKILL.md	核心操作手册。告诉 Agent 何时使用这个 Skill、抓取规则、去重方法、处理状态和短报要求;
- README.md	给人阅读的说明。介绍 V1 能做什么、如何安装、目录结构及安全边界;
- agents/	Codex 界面元数据，例如 Skill 显示名称、简短描述和默认调用提示。它不包含抓取逻辑;
- config/	可调整的运行配置。包括博主观察名单、时区、运行时间、短报日期、字数上限和重试设置;
- references/	补充架构资料。解释 ingestion 与 analysis 的分层、Obsidian 结构、安全边界和状态含义。Agent 需要时才读取;
- schemas/	数据格式验证规则。检查 ledger 是否具有正确字段和数据类型，避免账本损坏;
- scripts/	可重复执行的工具。目前的初始化脚本负责在 Obsidian 中建立目录，并复制初始配置和空账本;
- templates/	新建文件时使用的空白模板，包括 ledger、单条帖子笔记和投资短报格式;

## Quick start

1. Review config/influencer-watchlist.yaml and enable only verified X profiles.
2. Bootstrap an Obsidian vault:

   ~~~bash
   ./scripts/bootstrap-vault.sh "/path/to/your/Obsidian/vault"
   ~~~

3. Set FINANCIAL_INFLUENCER_VAULT to the vault root for scheduled runs.
4. Install or invoke the skill from SKILL.md.
5. Configure your scheduler from config/automation.yaml.
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
