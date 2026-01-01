Here is the framework for creating AI prompts called the KERNEL Method 

## K - Keep it simple
- Bad: 500 words of context
- Good: One clear goal
- Example: Instead of "I need hlep writing something about Redis," use "Write a technical tutorial on Redis caching"
- Results: 70% less toke usage, 3x faster responses

## E - Easy to verify
- Your prompt needs clear success criteria
- Replace "make it engaging" with "include 3 code examples"
- If you can't verify sucess, AI can't deliver it
- Results: 85% success rate with clear critieria vs. 41% without

## R - Reproducible results
- Avoid temporal references ("current trends", "lastest best practices")
- Use specific version and exact requirements
- Same prompt should work next week, next month
- Results: 90% consistency across 30 days in tests

## N - Narrow Scope
- One prompt = one goal
- Don't combine code + docs + tests in one request
- Split complex tesks
- Results: Single-goal prompts 89% satisfaction vs 41% for multi-goal

## E - Explicit constraints
- Tell AI what NOT to do
- "Python code" -> "Python code. No external libraries. No functions over 20 lines"
- Results: Constraints reduce unwanted outputs by 91%

## L - Logical structure format every prompt like:
    1) Context: (input)
    2) Task: (function)
    3) Constraints (parameters)
    4) Format: (output)

## Real Example
- Before Prompt: "Help me write a script to process some data files and make them more efficient"
- Results: 200 lines of generic, unusable code
- After applying KERNAL Prompt:

    1) Task: Python script to merge CSVs
    2) Input: Multiple CSVs, same columns
    3) Constraints: Pandas only <50 lines
    4) Output: Single merged.csv
    5) Verify: Run on test_data/
- Rsults: 37 lines, worked on first try

## Advanced Tip
- Chain mulitple KERNEL prompts instead of writing complex ones. Each prompt does one thing well, feeds into the next

