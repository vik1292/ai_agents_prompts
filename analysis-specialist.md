
Write a Python script using pandas to process two Excel workbooks:

## GOAL
- Read `master_inventory.xlsx` and store it as a DataFrame named `master`
- Read `hl_retirement_phases.xlsx`, load ALL sheets (there are 4 tabs), and store each sheet in a dict keyed by sheet name. Also bind each DataFrame to a variable named excatly as the sheet name (valid Python identifiers only).
- For each sheet in `hl_retirement_phases.xlsx`, perform a LEFT JOIN from `master` on:
    - master key: `Letter_ID`
    - sheet key: `communication_id`
- If there is a match for a given sheet, set `"X"` in a single `retire` column on `master` for the matching rows. (If multiple shees match the same row, it still stays `"X"`.)
- Produce:
    1) `master_output.csv`: all rows from `master` where `retire == "X"`.
    2) `error.csv`: rows from ALL datasets (both `master` and every sheet) that did NOT have a valid match. Include a `source_dataset` column indicating origin (e.g., `"master"` or the sheet name).

## REQUIREMENTS & ASSUMPTIONS
- Use `pandas` with `engine="openpyxl"` when reading Excel.
- Files are local in the current working directory and named excatly:
    - `master_inventory.xlsx`
    - `hl_retirement_phases.xlsx`
- Column names:
    - `master` has `Letter_ID`.
    - Each sheet has `communication_id`.
- Keys may have leading/trailing spaces or mixed types: normalize by:
    - Converting keys to string (`astype(str)`),
    - `.str.strip()`,
    - Optional `.str.upper() ( make sure matching is case-insensitive).
- If `retire` column does not exist in `master`, create it and default it to `""` (empty string).
- The LEFT JOIN should not duplicate `master` rows in the output. If a sheet has multiple matches for a single `Letter_ID`, treat it as matched and set `retire = "X"` (don't inflate rows).
- For `error.csv`:
    - Include unmatched `master` rows (those with `retire != "X"`) with `source_dataset="master"`.
    - Include unmatched rows from each sheet (those whose `communication_id` not found in `master["Letter_ID"]` after normalization) with `source_dataset` equal to the sheet name.
- Output CSVs should have `index=False`.
- Add simple logging/print statements to indicate progress: files read, sheet processed, counts of matches and errors, and output file paths.
- Organize code with functions and a `main()`:
    - `load_master(path) -> DataFrame`
    - `load_phases(path) -> Dict[str, DataFrame]`
    - `normalize_keys(df, colname) -> Series` (returns normalized key Series)
    - `mark_retire(master, phases_dict) -> DataFrame` (returns updated master with `retire` column)
    - `build_error_frames(master, phases_dict) -> DataFrame` (concatenates unmatched rows from all datasets with `source_dataset` column)
- Include basic error handling:
    - `FileNotFoundError` for missing files.
    - `KeyError` if required columns are missing in any sheet,
    - Friendly messages that tell which sheet failed and which column is missing.
- Ensure the script can be run as a module: `if __name__ == "__main__": main()`

## ACCEPTANCE CRITERIA
- `master` loads successfully from `master_inventory.xlsx`.
- All 4 sheets are loaded from `hl_retirement_phases.xlsx` and accessible by their tab names.
- After processing, `master` has a `retire` column; matching rows have `"X"`.
- `master_output.csv` contains only those rows with `retire == "X"`.
- `error.csv` includes:
    - All `master` rows with `retire != "X"`,
    - All sheet rows whose `communications_id` is not found in the normalized `master["Letter_ID"]`,
    - A `source_dataset` column indicating origin for every row.
- No duplicated `master` rows introduced by joins.
- Script logs counts (e.g., number of matched rows, numbers of errors from each dataset) and prints where the output files are saved.

## IMPLEMENTATION NOTES
- To avoid rows inflation during LEFT JOIN, use a membership check rather than merging full frames:
    - Build a normalized set of `Letter_ID` from `master`.
    - For each sheet, check `communication_id` membership in that set.
    - Set `retire = "X"` on `master` for keys that appear in ANY sheet.
- When binding sheet DataFrames to variables named as sheet names, sanitize names to valid Python identifiers (e.g., replace spaces and special chars with `_`), and keep the original sheet name in the dict.

Please implement this with clear comments and type hings.
``
