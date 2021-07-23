# cloudseed-deno

## Use:

E.g.

    import { exec } from "https://raw.githubusercontent.com/metapages/cloudseed-deno/v0.0.14/deno/mod.ts"

Change version and file to suit.

## Blurb

Deno scripts and tools for building, packaging, deploying, and publishing libraries and apps from repositories.

Primarily used by [cloudseed](https://github.com/metapages/cloudseed) based repositories where users need to manage many git repositories.

Designed to be used in conjuction with `justfile`s or consumed by other scripts.

## Repository setup

- Repository `Settings` -> `Branches` -> `Branch protection rule`
  - **main**:
    - ☑️ Require status checks to pass before merging
    - ☑️ Require branches to be up to date before merging
- Repository `Settings` -> `Secrets` -> `Repository secrets`
  - Add `PERSONAL_ACCESS_TOKEN` with write settings from
    - Personal `Settings` -> `Developer settings` -> `Personal access tokens` with permissions:
      - repo, write:packages
