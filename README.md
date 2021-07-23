# Deno source for cloudseed-based repositories

User documentation: https://deno.land/x/cloudseed

## Repository setup

- Repository `Settings` -> `Branches` -> `Branch protection rule`
  - **main**:
    - ☑️ Require status checks to pass before merging
    - ☑️ Require branches to be up to date before merging
- Repository `Settings` -> `Secrets` -> `Repository secrets`
  - Add `PERSONAL_ACCESS_TOKEN` with write settings from
    - Personal `Settings` -> `Developer settings` -> `Personal access tokens` with permissions:
      - repo, write:packages
