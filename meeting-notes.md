---
name: meeting-notes
description: >
  Use this skill whenever the user wants to generate, format, or clean up meeting notes.
  Triggers include: "write up meeting notes", "turn this transcript into notes", "summarize
  this meeting", "format my notes", "create meeting notes from this", or any time the user
  provides a transcript, rough bullet points, or a description of a meeting and wants a
  structured document out of it. Always use this skill when a meeting transcript or rough
  notes are provided — even if the user just says "clean this up" or "make notes from this".
  Produces both a .docx file and a Markdown version in chat.
---
 
# Meeting Notes Skill
 
Turns raw transcripts or rough bullet-point notes into clean, structured internal team meeting notes. Output is always **both** a `.docx` file and **Markdown rendered in chat**.
 
---
 
## Input types
 
- **Transcript** (verbatim text, auto-generated captions, etc.)
- **Rough notes** (bullet points, fragmented sentences, stream of consciousness)
- **Both** (use both as source material, reconcile any conflicts)
- **Verbal description** (user describes the meeting in the chat)
 
---
 
## Output structure
 
Always produce notes with these sections (omit a section only if there is genuinely nothing to put in it):
 
```
[Meeting Title]
Date: YYYY-MM-DD   |   Attendees: [names if known]
 
## TL;DR
2–4 sentence plain-English summary of what happened and why it mattered.
 
## Key Decisions
- [Decision 1]
- [Decision 2]
 
## Action Items
| Owner | Action | Due Date |
|-------|--------|----------|
| Name  | Task   | Date or TBD |
 
## Discussion Notes
### [Topic 1]
- ...
### [Topic 2]
- ...
 
## Next Steps / Follow-ups
- [Item 1]
- [Item 2]
```
 
---
 
## Tone & style
 
- **Casual internal team voice** — write like a smart colleague took the notes, not a lawyer
- Use plain language; avoid jargon unless it was actually used in the meeting
- Keep bullet points short and scannable
- Don't pad or over-explain — if something took 30 minutes to discuss but the outcome is one sentence, write one sentence
- Capture *decisions and actions*, not every word spoken
- If something is unclear or ambiguous in the source, use `[unclear]` rather than guessing
 
---
 
## File naming
 
Always name the `.docx` file using this pattern:
```
YYYY-MM-DD Meeting Notes - [Topic].docx
```
- Use today's date unless the meeting date is specified in the input
- Derive the topic from the meeting content (e.g. "Q1 Roadmap", "Sprint Retro", "Onboarding Sync")
- Keep the topic slug short (2–4 words)
 
Example: `2026-03-11 Meeting Notes - Sprint Retro.docx`
 
---
 
## Step-by-step workflow
 
### 1. Parse the input
- Identify the meeting date, attendees, and topic from the content if present
- If the input is a transcript, extract substance — skip filler ("um", "yeah", "so anyway")
- If the input is rough notes, infer structure and group related points
 
### 2. Draft the Markdown version in chat
- Always render the Markdown directly in the conversation first
- This gives the user a fast preview without needing to download anything
 
### 3. Create the .docx file
Follow the docx skill (see `/mnt/skills/public/docx/SKILL.md`) for document creation. Key formatting:
 
```javascript
// Document structure
- Title: bold, 16pt, Arial
- Date/Attendees line: 10pt, gray (#666666), below title
- Thin horizontal rule under the header (paragraph bottom border)
- Section headings: Heading 2 style, 13pt bold
- Sub-headings (Discussion topics): Heading 3 style, 12pt bold
- Body text: 11pt Arial, 1.15 line spacing
- Action items: rendered as a table (Owner | Action | Due Date)
  - Header row shaded light blue (#D5E8F0)
  - Column widths: 2000 | 5500 | 1860 DXA (sums to 9360 for US Letter 1" margins)
- Bullets: use LevelFormat.BULLET (never unicode bullets)
- Page size: US Letter (12240 x 15840 DXA), 1" margins
```
 
### 4. Validate and save
```
Save file with the following naming "YYYY-MM-DD Meeting Notes - Topic.docx"
```

---
 
## Edge cases
 
| Situation | How to handle |
|-----------|--------------|
| No attendees listed | Omit the Attendees field entirely |
| No clear decisions | Omit the Key Decisions section |
| No action items | Omit the Action Items table |
| Very short meeting / standup | TL;DR + Action Items is sufficient; skip other sections |
| Multiple topics in one meeting | Create sub-headings under Discussion Notes |
| Date not mentioned | Use today's date and note "(date assumed)" next to it |
| Owner not assigned for an action | Use "TBD" in the Owner column |
 
---
 
## Example (short)
 
**Input:**
> talked about the new onboarding flow. Sarah demoed the updated Figma. We agreed to go with Option B. Jake will update the Notion doc by Friday. Still need to loop in the eng team.
 
**Output:**
 
```
2026-03-11 Meeting Notes - Onboarding Flow
 
Date: 2026-03-11
 
## TL;DR
The team reviewed Sarah's updated Figma prototype for the new onboarding flow and aligned on Option B. Jake has a follow-up task and engineering needs to be looped in.
 
## Key Decisions
- Selected Option B for the new onboarding flow
 
## Action Items
| Owner | Action | Due Date |
|-------|--------|----------|
| Jake  | Update Notion doc with onboarding flow decision | 2026-03-14 |
| TBD   | Loop in engineering team | TBD |
 
## Discussion Notes
### Onboarding Flow Review
- Sarah demoed the updated Figma prototype
- Team discussed options and aligned on Option B
 
## Next Steps / Follow-ups
- Engineering team needs to be included in next review
```