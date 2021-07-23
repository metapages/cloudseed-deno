# cloudseed-deno

Deno scripts and tools for building, packaging, deploying, and publishing libraries and apps from repositories.

Primarily used by [cloudseed](https://github.com/metapages/cloudseed) based repositories where users need to manage many git repositories.

Designed to be used in conjuction with `justfile`s or consumed by other scripts.

## Repository setup

- `Settings` -> `Branches` -> `Branch protection rule`
  - **main**:
    - ☑️ Require status checks to pass before merging
    - ☑️ Require branches to be up to date before merging
- `Settings` -> `Secrets` -> `Repository secrets`
  - Add `PERSONAL_ACCESS_TOKEN` with write settings from
    - `Settings` -> `Developer settings` -> `Personal access tokens` with permissions:
      - repo, write:packages
