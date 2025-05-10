import os
import zipfile
from datetime import datetime

# Define base path for the vault
base_path_final = "/mnt/data/ResearchVault_StarterPack"

# Folder structure
folders = [
    "00 Inbox",
    "01 Papers",
    "02 Literature Notes",
    "03 Permanent Notes",
    "04 Topics",
    "99 Templates"
]

# Create folder structure
for folder in folders:
    os.makedirs(os.path.join(base_path_final, folder), exist_ok=True)

# Add README files for context
readme_contents = {
    "00 Inbox": "Drop raw ideas, quick thoughts, and unfinished notes here.",
    "01 Papers": "Store and link your physics research papers (PDFs or notes) here.",
    "02 Literature Notes": "Take notes directly from physics research papers with summary, key points, and your thoughts.",
    "03 Permanent Notes": "Write your permanent Zettelkasten notes here—atomic, evergreen insights in your own words.",
    "04 Topics": "Organize related physics notes, questions, and themes here.",
    "99 Templates": "Reusable note templates. Copy or insert into new notes for consistency."
}

for folder, content in readme_contents.items():
    with open(os.path.join(base_path_final, folder, "README.md"), "w") as f:
        f.write(f"# {folder}\n\n{content}")

# Add enhanced templates
templates = {
    "Literature Note Template.md": """---
title: "{{title}}"
source: "{{source}}"
authors: "{{authors}}"
status: unread
subfield: "{{subfield}}"
tags: ["#literature", "#physics"]
created: {{date}}
last_modified: {{date}}
related_notes: []
---

# {{title}}

| **Field**       | **Details**                       |
|-----------------|-----------------------------------|
| **Authors**     | {{authors}}                      |
| **Source**      | {{source}}                       |
| **DOI**         | {{doi}}                          |
| **arXiv ID**    | {{arxiv_id}}                     |
| **PDF Link**    | {{pdf_link}}                     |
| **Subfield**    | {{subfield}} (e.g., Quantum Mechanics, Astrophysics) |
| **Status**      | {{status}} (e.g., unread, read, summarized) |
| **Tags**        | {{tags}}                         |

## Summary
Provide a concise summary of the paper (2-3 sentences).

## Key Points
- **Point 1**: Summarize a key finding or argument (e.g., novel theoretical model).
- **Point 2**: Highlight a critical insight (e.g., experimental result).
- **Point 3**: Note methodologies or data of interest.

## Methodology
- Describe the theoretical or experimental approach.
- Example: $$ E = mc^2 $$ (use LaTeX for equations).

## My Thoughts
- How does this paper advance your research in {{subfield}}?
- What questions or critiques arise?
- Potential applications or gaps?

## Quotes
> "Insert notable quote here." — Page X

## Zettel Links
- Related Permanent Notes: [[Note ID or Title]]
- Related Topics: [[Topic Name]]

## References
- Cite related papers or sources mentioned in the text.
""",
    "Permanent Note Template.md": """---
title: "{{title}}"
id: "{{unique_id}}"
subfield: "{{subfield}}"
tags: ["#zettel", "#physics"]
created: {{date}}
last_modified: {{date}}
related_notes: []
---

# {{title}}

## Core Idea
State the single, atomic idea of this note in 1-2 sentences.

## Explanation
- Provide context or background for the idea in {{subfield}}.
- Explain why this insight matters (e.g., implications for theory or experiment).
- Include examples, equations (e.g., $$ F = ma $$), or evidence.

## Links
- **Related Zettels**: [[Note ID or Title]]
- **Source Literature**: [[Literature Note Title]]
- **Topics**: [[Topic Name]]

## References
- Cite sources or inspirations (e.g., papers, books, talks).

## Notes
- Add any additional thoughts or future considerations.
""",
    "Daily Note Template.md": """---
title: "{{date}}"
tags: ["#daily"]
created: {{date}}
last_modified: {{date}}
---

# {{date}}

## Tasks
- [ ] Task 1: Description
- [ ] Task 2: Description

## Thoughts
- Capture fleeting ideas or reflections.
- What inspired or challenged you today?

## Notes
- **Meetings/Conversations**: Summarize key points.
- **Research Progress**: Log experiments, readings, or insights.
- **Links**: [[Related Note or Topic]]

## Next Steps
- What to focus on tomorrow?
""",
    "Paper Template.md": """---
title: "{{title}}"
authors: "{{authors}}"
source: "{{source}}"
doi: "{{doi}}"
arxiv_id: "{{arxiv_id}}"
subfield: "{{subfield}}"
type: "{{type}}"
tags: ["#paper", "#physics"]
created: {{date}}
last_modified: {{date}}
---

# {{title}}

| **Field**       | **Details**                       |
|-----------------|-----------------------------------|
| **Authors**     | {{authors}}                      |
| **Source**      | {{source}} (e.g., journal, arXiv) |
| **DOI**         | {{doi}}                          |
| **arXiv ID**    | {{arxiv_id}}                     |
| **Subfield**    | {{subfield}} (e.g., Particle Physics, Cosmology) |
| **Type**        | {{type}} (e.g., Theoretical, Experimental) |

## Abstract
Copy the paper's abstract here.

## Key Equations
- Equation 1: $$ <insert LaTeX equation> $$ — Description.
- Equation 2: $$ <insert LaTeX equation> $$ — Description.

## Experimental/Theoretical Setup
- Describe the experiment, simulation, or theoretical framework.
- Include diagrams or figures if applicable (reference figure numbers).

## Results
- Summarize the main findings or predictions.
- Note any significant data or outcomes.

## Links
- **Literature Note**: [[Literature Note for {{title}}]]
- **Topics**: [[Topic Name]]

## Notes
- Add personal annotations or observations.
- Flag any sections needing further reading.
""",
    "Topic Template.md": """---
title: "{{title}}"
subfield: "{{subfield}}"
tags: ["#topic", "#physics"]
created: {{date}}
last_modified: {{date}}
related_notes: []
---

# {{title}}

## Overview
Provide a brief introduction to the topic in {{subfield}} (e.g., String Theory, Black Hole Physics).

## Key Questions
- What are the central research questions in this topic?
- Example: How does {{title}} explain {{phenomenon}}?

## Key Notes
- [[Permanent Note Title]]: Summarize key insight.
- [[Literature Note Title]]: Highlight relevant paper.

## Equations and Models
- Equation: $$ <insert LaTeX equation> $$ — Explanation.
- Model: Describe a key theoretical model or framework.

## Open Problems
- List unresolved questions or challenges in {{title}}.
- Example: Lack of experimental evidence for {{hypothesis}}.

## Links
- **Related Topics**: [[Other Topic Name]]
- **Papers**: [[Paper Title]]

## References
- Cite key papers, books, or reviews on {{title}}.
"""
}

# Write templates to 99 Templates and copy to relevant folders
for name, content in templates.items():
    # Replace {{date}} with current date
    current_date = datetime.now().strftime("%Y-%m-%d")
    content = content.replace("{{date}}", current_date)
    # Always save to 99 Templates
    template_path = os.path.join(base_path_final, "99 Templates", name)
    with open(template_path, "w") as f:
        f.write(content)

# Copy templates into relevant folders
template_copies = {
    "00 Inbox": "Daily Note Template.md",
    "01 Papers": "Paper Template.md",
    "02 Literature Notes": "Literature Note Template.md",
    "03 Permanent Notes": "Permanent Note Template.md",
    "04 Topics": "Topic Template.md"
}

for folder, template_name in template_copies.items():
    source_path = os.path.join(base_path_final, "99 Templates", template_name)
    target_path = os.path.join(base_path_final, folder, template_name)
    with open(source_path, "r") as src, open(target_path, "w") as dst:
        dst.write(src.read())

# Zip the entire vault
zip_path = "ResearchVault_StarterPack.zip"
with zipfile.ZipFile(zip_path, 'w') as zipf:
    for root, dirs, files in os.walk(base_path_final):
        for file in files:
            file_path = os.path.join(root, file)
            arcname = os.path.relpath(file_path, base_path_final)
            zipf.write(file_path, arcname)

print(f"Vault zipped at: {zip_path}")