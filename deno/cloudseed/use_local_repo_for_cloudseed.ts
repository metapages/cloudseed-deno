/**
 * Use a local copy of this repo for development
 * 1. Check out the repo https://github.com/metapages/cloudseed-deno at: {path} (default: `./cloudseed/git/cloudseed-deno`)
 * 2. Change/add the env var `DENO_SOURCE` in `.env` files to point to the above repo, so
 *    that [just](https://github.com/casey/just) files will consume the updated reference,
 *    and point all deno scripts to the local git repo.
 * 3. Edit and update
 * 4. After: make a PR with the new changes
 */

import { join, dirname } from "https://deno.land/std@0.130.0/path/mod.ts";
import {
  ensureDirSync,
  existsSync,
} from "https://deno.land/std@0.130.0/fs/mod.ts";
import { exec, OutputMode } from "../exec/mod.ts";
import { getGitRepositoryRoot } from "../git/mod.ts";
import { ensureLineExistsInFile } from "../fs/mod.ts";
import { getArgsFromEnvAndCli } from "../env/args_or_env.ts";

// If we are given a path, use that and set as DENO_SOURCE
const { path }:{path:string|undefined} = getArgsFromEnvAndCli({path:false})

let cloudseedGitDir = path;
const gitRoot = await getGitRepositoryRoot();

if (!cloudseedGitDir) {
  // Make up a local path for the cloudseed repo
  const cloudseedCloneRoot = join(gitRoot, ".cloudseed/git");
  cloudseedGitDir = join(cloudseedCloneRoot, "cloudseed-deno");
}
// Make sure the git repo is cloned to the local folder
if (!existsSync(cloudseedGitDir)) {
  ensureDirSync(dirname(cloudseedGitDir));
  const process = await exec(
    "git clone https://github.com/metapages/cloudseed-deno",
    { cwd: dirname(cloudseedGitDir), output: OutputMode.Tee }
  );
}

await ensureLineExistsInFile({
  file: join(gitRoot, ".env"),
  line: `DENO_SOURCE=${cloudseedGitDir}/deno`,
});
