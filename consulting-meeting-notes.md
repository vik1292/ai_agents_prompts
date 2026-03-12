---
name: consulting-meeting-notes
description: >
  Use this skill to generate McKinsey-style consulting meeting notes from transcripts,
  rough notes, or verbal descriptions. Triggers include: "consulting meeting notes",
  "McKinsey-style notes", "client meeting notes", "engagement team notes", "write up
  the client readout", "format these meeting notes for the client", "turn this into
  consulting notes", or any time the user asks for meeting documentation in a professional
  consulting context. Always use this skill when the user is in a client-facing or
  engagement-team context, even if they just say "clean this up" or "make notes from this".
  Produces both a .docx file and a Markdown version in chat. Preferred over the standard
  meeting-notes skill for any consulting, client, or engagement-team meeting context.
---
 
# Consulting Meeting Notes Skill
 
Produces **McKinsey-style** meeting notes from transcripts, rough bullets, or verbal descriptions.
Output is always **both** a `.docx` file (executive-ready) and **Markdown rendered in chat**.
 
---
 
## McKinsey Writing Principles
 
These govern every sentence written in the notes:
 
- **Action-oriented headlines** — every section title is a complete, insight-driven sentence, not a label.
  - ❌ "Project Timeline" → ✅ "Timeline compressed to 10 weeks; workstream leads to confirm by Friday"
  - ❌ "Risks" → ✅ "Three open risks require resolution before Phase 2 gate"
- **Pyramid principle** — lead with the conclusion, support with evidence. Never bury the "so what."
- **So what framing** — every bullet answers: *why does this matter?* Remove bullets that don't.
- **Tight, active language** — eliminate "it was discussed that", "we talked about", "there was agreement". Write what was decided or what will happen.
- **No filler** — cut hedges ("sort of", "kind of"), throat-clearing ("as mentioned"), and redundancy.
- **Numbered bullets for sequenced items**, dashes for non-ordered lists.
- **Consistent tense** — use past tense for what happened, future tense for what will happen.
 
---
 
## Output structure
 
```
[Engagement / Project Name] — Meeting Notes
[Meeting Type] | Date: YYYY-MM-DD | Attendees: [Name (Role/Firm), ...]
 
─────────────────────────────────────────────
 
## Executive Summary
[2–3 sentence synthesis: what was resolved, what remains open, and the critical path forward.]
 
## Decisions & Alignments
- [Decision stated as a declarative sentence with owner if applicable]
 
## Open Issues & Risks
| # | Issue / Risk | Owner | Resolution Path | Due |
|---|-------------|-------|----------------|-----|
| 1 | ...          | ...   | ...            | ... |
 
## Discussion
### [Action headline for Topic 1]
- [Insight-driven bullet — so what first]
- ...
 
### [Action headline for Topic 2]
- ...
 
## Immediate Next Steps
| # | Action | Owner | Due Date |
|---|--------|-------|----------|
| 1 | ...    | ...   | ...      |
 
## Appendix / Context (optional)
- Background or reference material that informed the discussion but doesn't belong in the main body
```
 
---
 
## Tone & style
 
- **Formal, precise, and assertive** — write like a McKinsey associate producing a client-ready document
- Use consulting vocabulary naturally: *workstream, hypothesis, pressure-test, align on, gate, escalate, strawman, go-forward*
- Avoid casualness: no "we", no "basically", no "kind of"
- Every bullet should be able to stand alone — a reader skimming only the bullets gets the full picture
- Use title case for section headlines
- **Attendee format:** `First Last (Role, Firm)` — e.g., `Sarah Kim (Engagement Manager, McKinsey)`, `John Doe (CFO, Client Co.)`
 
---
 
## File naming
 
```
YYYY-MM-DD Meeting Notes - [Engagement / Topic].docx
```
- Use today's date unless the meeting date is specified
- Topic should reflect the engagement or project name if known (e.g. "Auto Lending Transformation", "Digital Transformation")
- Example: `2026-03-11 Meeting Notes - Collections Optimization.docx`
 
---
 
## Step-by-step workflow
 
### 1. Parse and structure the input
- Identify: meeting date, meeting type (e.g. working session, client readout, team sync, steering committee), attendees with roles/firms, and primary topic
- Strip all filler from transcripts; extract only substance
- Group related discussion points under unified action-headline topics
- Identify decisions (resolved) vs. open issues (unresolved) — keep them strictly separate
 
### 2. Apply McKinsey writing pass
Before drafting, ask for each bullet:
- Does this lead with the insight or conclusion?
- Is there a clear "so what"?
- Is the language active and tight?
- Would a partner reading only this bullet understand what happened and why it matters?
 
### 3. Draft Markdown in chat first
- Render the complete notes in Markdown in the conversation for fast review
- Flag any gaps, ambiguities, or `[unclear]` items explicitly
 
### 4. Create the .docx file
Read `/mnt/skills/public/docx/SKILL.md` for full docx-js implementation details.
 
**Formatting spec:**
 
```javascript
// Typography
- Font: Arial throughout
- Document title: 18pt, bold, black (#000000)
- Subtitle line (meeting type | date | attendees): 10pt, dark gray (#444444), italic
- Horizontal rule under header: paragraph bottom border, 2pt, McKinsey blue (#005587)
- Section headings (H2): 12pt, bold, McKinsey blue (#005587), 12pt spacing before
- Sub-headings (H3 — discussion topics): 11pt, bold, black, 6pt spacing before
- Body text: 11pt, 1.15 line spacing
- Page size: US Letter (12240 x 15840 DXA), 1" margins
 
// Color palette
- McKinsey Blue: #005587  (headings, rule, table headers)
- Light blue tint: #D6E8F3  (table header shading)
- Dark gray: #444444  (subtitle / metadata)
- Black: #000000  (body text)
 
// Tables (Action Items and Open Issues)
- Use ShadingType.CLEAR with fill #D6E8F3 for header rows
- Border: BorderStyle.SINGLE, size: 1, color: #CCCCCC
- Column widths (Action Items — 4 cols, content width 9360 DXA):
    [400, 5160, 2000, 1800]  → #, Action, Owner, Due Date
- Column widths (Open Issues — 5 cols):
    [400, 3360, 1500, 2700, 800]  → #, Issue/Risk, Owner, Resolution Path, Due
- Cell margins: { top: 80, bottom: 80, left: 120, right: 120 }
- Always set dual widths: columnWidths array AND width on each cell
 
// Lists
- Use LevelFormat.BULLET with proper numbering config (never unicode bullets)
- Use LevelFormat.DECIMAL for numbered/sequenced items
```
 
### 5. Validate and save
```
Save file with the following naming "YYYY-MM-DD Meeting Notes - Topic.docx"
```
 
---
 
## Edge cases
 
| Situation | How to handle |
|-----------|--------------|
| No attendee roles known | Use names only, omit firm/role |
| No decisions made | Replace section with "No decisions reached; see Open Issues" |
| All issues resolved | Omit Open Issues table |
| Steering committee / exec readout | Elevate Executive Summary to 4–5 sentences; compress discussion detail |
| Internal team sync (no client) | Note "(Internal)" after meeting type in subtitle; keep same format |
| Sensitive client info in notes | Add "CONFIDENTIAL — McKinsey & Company" as a footer |
| Date not mentioned | Use today's date with "(date assumed)" |
| Action owner not assigned | Use "TBD" — never leave the Owner column blank |
 
---
 
## Example
 
**Input:**
> Quick sync on the auto lending transformation. Victor walked through the updated sizing model. The team agreed the 8% RPC-to-payment conversion assumption is too aggressive — we'll use 6% for the base case. Sarah will rerun the waterfall by Thursday. Still debating whether to include early-stage repos in scope — need partner sign-off. Next client readout is in two weeks.
 
**Output (Markdown):**
 
```
Auto Lending Transformation — Meeting Notes
Working Session | Date: 2026-03-11 | Attendees: Victor (Engagement Manager, McKinsey), Sarah (Associate, McKinsey)
 
─────────────────────────────────────────────
 
## Executive Summary
The team aligned on a more conservative RPC-to-payment conversion assumption (6% vs. 8%) for the sizing model base case, improving credibility ahead of the client readout in two weeks. One scoping question — early-stage repo inclusion — remains open pending partner sign-off.
 
## Decisions & Alignments
- Base case RPC-to-payment conversion rate revised downward from 8% to 6%; prior assumption deemed too aggressive given observed data
 
## Open Issues & Risks
| # | Issue / Risk | Owner | Resolution Path | Due |
|---|-------------|-------|----------------|-----|
| 1 | Early-stage repo scope inclusion undecided | Victor | Escalate to partner for sign-off | Before client readout |
 
## Discussion
### Sizing Model Assumptions Require Recalibration to Reflect Observed Performance
- Victor presented the updated sizing model; team pressure-tested the RPC-to-payment conversion rate
- 8% assumption flagged as too aggressive relative to observed collections data; 6% adopted as base case
- Revised assumption improves defensibility with client; upside scenario may retain 8% for sensitivity analysis
 
## Immediate Next Steps
| # | Action | Owner | Due Date |
|---|--------|-------|----------|
| 1 | Rerun sizing model waterfall using 6% base case conversion rate | Sarah | 2026-03-13 |
| 2 | Obtain partner sign-off on early-stage repo scope inclusion | Victor | Before client readout |
```