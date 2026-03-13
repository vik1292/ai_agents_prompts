---
name: performance-evaluation
description: >
  Use this skill to conduct a structured interview and generate a professional year-end
  performance self-evaluation in a polished .docx file. Triggers include: "write my performance
  review", "help me with my self-evaluation", "year-end review", "performance eval",
  "self-assessment", "write up my accomplishments", "help me document my impact this year",
  or any request to create or draft a professional performance review document. Always use
  this skill when the user wants to produce a performance evaluation — even if they say
  "just help me write it up" or "turn my notes into a review". Produces a .docx file with
  three versions: Comprehensive (750–1000 words), Concise (400–500 words), and Bullet-Point.
---
 
# Performance Evaluation Skill
 
## Overview
 
This skill conducts a structured interview with the user to gather their accomplishments,
then produces a polished, McKinsey-style year-end self-evaluation in a .docx file.
 
The output contains **three versions** in one document:
1. **Comprehensive** (750–1000 words) — for detailed submission portals
2. **Concise** (400–500 words) — for character-limited systems
3. **Bullet-Point** — for structured forms
 
---
 
## PHASE 1: INTERVIEW
 
Before generating anything, conduct the interview. Ask questions ONE AT A TIME. Do not
dump multiple questions at once. Use a warm, encouraging tone.
 
### Foundation Questions (ask all of these)
 
1. What is your role/title, and what were your primary responsibilities this year?
2. What were your top 3–5 official goals or OKRs at the start of the year?
3. Which projects consumed the majority of your time?
4. How is success/impact measured in your role?
 
### Achievement Deep-Dive (ask for each major project/accomplishment)
 
Use the STAR framework to probe:
- **Situation**: What was the business problem or opportunity?
- **Task**: What was your specific responsibility?
- **Action**: What did you do? What decisions did you make?
- **Result**: What was the measurable outcome?
 
Probing follow-ups to use as needed:
- "Can you quantify that impact — time saved, cost reduced, revenue influenced?"
- "What would have happened if you hadn't done this?"
- "Who else was involved, and what was your specific contribution?"
- "What was the timeline?"
- "What innovative approach did you use?"
- "How did this go above and beyond your core responsibilities?"
 
### Challenges & Growth (ask 2–3)
 
- What was your biggest challenge this year, and how did you navigate it?
- What skill or capability did you develop that you didn't have 12 months ago?
- What feedback did you receive, and how did you act on it?
 
### Collaboration & Impact (ask 2–3)
 
- How did you partner cross-functionally? Name specific teams/stakeholders.
- How did your work enable others to be successful?
- What's an example of you influencing without authority?
 
### Forward-Looking (ask 1–2)
 
- What capabilities do you want to develop next year?
- How do you see your role evolving?
 
### Interview Completion Signal
 
When you have sufficient information across all phases (minimum: role context, 2–3 major
accomplishments with results, 1 challenge, collaboration examples), say:
 
> "I have everything I need to write a compelling performance review. Let me generate your
> document now."
 
Then proceed to document generation.
 
---
 
## PHASE 2: DOCUMENT GENERATION
 
### Setup
 
Read `/mnt/skills/public/docx/SKILL.md` for full docx-js syntax before writing code.
 
Install dependencies:
```bash
npm install -g docx 2>/dev/null || true
```
 
### Document Structure
 
Produce a single .docx with three clearly separated sections using page breaks.
 
**Document header** (appears once at top):
- Name/role (if provided) or "Year-End Performance Self-Evaluation"
- Review period (e.g., "FY 2025" or current year)
- Date generated
 
**Section 1: COMPREHENSIVE VERSION** (~750–1000 words)
```
SECTION 1: COMPREHENSIVE VERSION
(750–1000 words | For detailed submission portals)
─────────────────────────────────────────────────
 
EXECUTIVE SUMMARY
[3–4 sentences: overall performance, key themes, value delivered]
 
GOAL ACHIEVEMENT & KEY ACCOMPLISHMENTS
[For each major accomplishment:]
  Objective: [what was the goal]
  Approach: [how you executed it — technical decisions, leadership]
  Impact: [measurable results with metrics]
 
CORE COMPETENCIES & TECHNICAL EXCELLENCE
[Technical skills applied, problem-solving, innovation, quality]
 
COLLABORATION & LEADERSHIP
[Cross-functional partnerships, mentorship, influence, stakeholder management]
 
CHALLENGES NAVIGATED & GROWTH
[Obstacles overcome, lessons learned, skills developed]
 
FUTURE FOCUS
[Development areas, alignment with org priorities]
```
 
**Section 2: CONCISE VERSION** (~400–500 words)
```
SECTION 2: CONCISE VERSION
(400–500 words | For character-limited systems)
─────────────────────────────────────────────────
 
[Distilled version covering: summary sentence, top 3 accomplishments with metrics,
collaboration highlights, one challenge + growth, forward focus]
```
 
**Section 3: BULLET-POINT VERSION**
```
SECTION 3: BULLET-POINT VERSION
(Structured form format)
─────────────────────────────────────────────────
 
KEY ACCOMPLISHMENTS:
• [accomplishment with metric]
• [accomplishment with metric]
• [accomplishment with metric]
 
TECHNICAL SKILLS DEMONSTRATED:
• [skill]
• [skill]
 
COLLABORATION & LEADERSHIP:
• [example]
• [example]
 
CHALLENGES & GROWTH:
• [challenge navigated]
• [skill developed]
 
GOALS FOR NEXT YEAR:
• [goal]
• [goal]
```
 
### Writing Tone Requirements
 
- Confident but not arrogant
- Data-driven: include specific metrics wherever possible
- Action-oriented verbs: delivered, architected, optimized, led, transformed, drove, spearheaded, enabled, pioneered
- Professional but authentic
- Frame challenges as growth opportunities
 
### JavaScript Template
 
```javascript
const { Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
        PageBreak, BorderStyle, LevelFormat, WidthType } = require('docx');
const fs = require('fs');
 
// Color palette
const DARK_BLUE = "1F3864";
const MID_BLUE = "2E75B6";
const LIGHT_GRAY = "F2F2F2";
const DIVIDER_COLOR = "2E75B6";
 
const doc = new Document({
  numbering: {
    config: [
      {
        reference: "bullets",
        levels: [{
          level: 0, format: LevelFormat.BULLET, text: "•",
          alignment: AlignmentType.LEFT,
          style: { paragraph: { indent: { left: 720, hanging: 360 } } }
        }]
      }
    ]
  },
  styles: {
    default: { document: { run: { font: "Arial", size: 22 } } },
    paragraphStyles: [
      {
        id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal",
        run: { size: 32, bold: true, font: "Arial", color: DARK_BLUE },
        paragraph: { spacing: { before: 360, after: 120 }, outlineLevel: 0 }
      },
      {
        id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal",
        run: { size: 26, bold: true, font: "Arial", color: MID_BLUE },
        paragraph: { spacing: { before: 240, after: 80 }, outlineLevel: 1 }
      },
      {
        id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal",
        run: { size: 22, bold: true, font: "Arial", color: "404040" },
        paragraph: { spacing: { before: 160, after: 60 }, outlineLevel: 2 }
      }
    ]
  },
  sections: [{
    properties: {
      page: {
        size: { width: 12240, height: 15840 },
        margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
      }
    },
    children: [
      // Document title
      new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun({ text: "Year-End Performance Self-Evaluation", bold: true })]
      }),
      new Paragraph({
        children: [new TextRun({ text: "FY 2025  |  Generated [DATE]", color: "666666", italics: true, size: 20 })]
      }),
      divider(),
 
      // ── SECTION 1: COMPREHENSIVE ──
      sectionHeader("SECTION 1: COMPREHENSIVE VERSION"),
      subNote("750–1000 words  |  For detailed submission portals"),
      divider(),
 
      heading2("Executive Summary"),
      body("[Executive summary content]"),
 
      heading2("Goal Achievement & Key Accomplishments"),
      // ... accomplishments
 
      heading2("Core Competencies & Technical Excellence"),
      body("[Technical content]"),
 
      heading2("Collaboration & Leadership"),
      body("[Collaboration content]"),
 
      heading2("Challenges Navigated & Continuous Improvement"),
      body("[Challenges content]"),
 
      heading2("Future Focus"),
      body("[Future focus content]"),
 
      // ── PAGE BREAK → SECTION 2 ──
      new Paragraph({ children: [new PageBreak()] }),
 
      sectionHeader("SECTION 2: CONCISE VERSION"),
      subNote("400–500 words  |  For character-limited systems"),
      divider(),
      body("[Concise version content]"),
 
      // ── PAGE BREAK → SECTION 3 ──
      new Paragraph({ children: [new PageBreak()] }),
 
      sectionHeader("SECTION 3: BULLET-POINT VERSION"),
      subNote("Structured form format"),
      divider(),
 
      heading2("Key Accomplishments"),
      bullet("Accomplishment with metric"),
      bullet("Accomplishment with metric"),
 
      heading2("Technical Skills Demonstrated"),
      bullet("Skill"),
 
      heading2("Collaboration & Leadership"),
      bullet("Example"),
 
      heading2("Challenges & Growth"),
      bullet("Challenge navigated"),
 
      heading2("Goals for Next Year"),
      bullet("Goal"),
    ]
  }]
});
 
// Helper functions
function divider() {
  return new Paragraph({
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: DIVIDER_COLOR, space: 1 } },
    spacing: { after: 120 },
    children: []
  });
}
 
function sectionHeader(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    children: [new TextRun({ text, bold: true })]
  });
}
 
function subNote(text) {
  return new Paragraph({
    children: [new TextRun({ text, italics: true, color: "666666", size: 20 })]
  });
}
 
function heading2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    children: [new TextRun({ text })]
  });
}
 
function body(text, bold = false) {
  return new Paragraph({
    spacing: { after: 120 },
    children: [new TextRun({ text, bold, size: 22 })]
  });
}
 
function bullet(text) {
  return new Paragraph({
    numbering: { reference: "bullets", level: 0 },
    spacing: { after: 60 },
    children: [new TextRun({ text, size: 22 })]
  });
}
 
Packer.toBuffer(doc).then(buf => {
  fs.writeFileSync('/mnt/user-data/outputs/performance_evaluation.docx', buf);
  console.log('Done');
});
```
 
### File Naming
 
Save to: `/mnt/user-data/outputs/performance_evaluation_[YEAR].docx`
 
### Validation
 
```bash
python /mnt/skills/public/docx/scripts/office/validate.py /mnt/user-data/outputs/performance_evaluation_[YEAR].docx
```
 
---
 
## QUALITY CHECKLIST
 
Before presenting the file, verify:
- [ ] All three versions are present and clearly labeled
- [ ] Page breaks separate each section
- [ ] Comprehensive version is 750–1000 words
- [ ] Concise version is 400–500 words
- [ ] Bullet-point version has all 5 categories
- [ ] Metrics and specifics are woven in (not generic filler)
- [ ] Action verbs lead each accomplishment
- [ ] Challenges are framed as growth, not failures
- [ ] Document validates without errors
 
---
 
## IMPORTANT NOTES
 
- Never rush to generate before completing the interview — quality depends on specificity
- If the user provides sparse answers, probe with "Can you give me a specific example?" or
  "What was the measurable outcome?"
- If the user already has notes/bullet points, accept them as Phase 1 input and skip to generation
- Always celebrate their wins authentically during the interview
- Preserve the user's authentic voice while elevating the professional framing