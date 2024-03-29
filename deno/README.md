## Cloudseed

Deno scripts and tools for building, packaging, deploying, and publishing libraries and apps from repositories.

Primarily used by [cloudseed](https://github.com/metapages/cloudseed) based repositories where users need to manage many git repositories.

Designed to be used in conjuction with `justfile`s or consumed by other scripts.

## Use:

E.g. (adjust version and file as appropriate)

    import { exec } from "https://deno.land/x/cloudseed@v0.0.15/mod.ts"

Or

    import { exec } from "https://raw.githubusercontent.com/metapages/cloudseed-deno/v0.0.15/deno/mod.ts"


## Switch between local and remote

Situation: you would like to use a local version of the cloudseed deno scripts. For example, you are developing and notice a bug or missing feature:

```deno
    deno run --unstable --allow-all https://raw.githubusercontent.com/metapages/cloudseed-deno/main/deno/cloudseed/use_local_repo_for_cloudseed.ts --path=<optional path to existing repo>
```

This will:

1. Check out the repo https://github.com/metapages/cloudseed-deno at `<path>` (defaults to `./cloudseed/git/cloudseed-deno`)
2. Change the env var `DENO_SOURCE` in `.env` files to point to the above repo, so that [just](https://github.com/casey/just) files will consume the updated reference, and point all deno scripts to the local git repo.
3. Edit and update
4. After: make a PR with the new changes

When you would like to revert:

1. Update hard references of `DENO_SOURCE` to the updated remote source
```deno
    deno run --unstable --allow-all https://raw.githubusercontent.com/metapages/cloudseed-deno/main/deno/cloudseed/use_remote_repo_for_cloudseed.ts
```

This will reset the `DENO_SOURCE` (remove it from `.env` files)

## Description/examples

Coming soon
