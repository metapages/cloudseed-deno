# just docs: https://github.com/casey/just
set shell                          := ["bash", "-c"]
ROOT                               := env_var_or_default("GITHUB_WORKSPACE", `git rev-parse --show-toplevel`)
export DOCKER_IMAGE_PREFIX         := "ghcr.io/metapages/cloudseed-deno"
# Always assume our current cloud ops image is versioned to the exact same app images we deploy
export DOCKER_TAG                  := `if [ "${GITHUB_ACTIONS}" = "true" ]; then echo "${GITHUB_SHA}"; else echo "$(git rev-parse --short=8 HEAD)"; fi`
# minimal formatting, bold is very useful
bold                               := '\033[1m'
normal                             := '\033[0m'

_help:
    #!/usr/bin/env bash
    # exit when any command fails
    set -euo pipefail
    if [ -f /.dockerenv ]; then
        just --list --unsorted --list-heading $'🌱 Commands:\n\n';
    else
        just _docker;
    fi

# [patch|minor|major] Publish a new tagged release https://deno.land/x/version@v1.1.0
@publish +args="patch":
    version {{args}}
    git push origin $(cat VERSION)

test:
    deno test --allow-run --fail-fast

watch:
    watchexec --exts ts -- just test

# Do git/ops/cloud operations in docker with all required tools installed, including local bash history
# Build and run the cloud image, used deployments
@_docker: _build_docker
    echo -e "🚪🚪 Entering docker context: {{bold}}{{DOCKER_IMAGE_PREFIX}}cloud:{{DOCKER_TAG}} from <cloud/>Dockerfile 🚪🚪{{normal}}"
    mkdir -p {{ROOT}}/.tmp
    touch {{ROOT}}/.tmp/.bash_history
    export WORKSPACE=/repo && \
        docker run \
            --rm \
            -ti \
            -e DOCKER_IMAGE_PREFIX=${DOCKER_IMAGE_PREFIX} \
            -e PS1="< \w/> " \
            -e PROMPT="<%/% > " \
            -e DOCKER_IMAGE_PREFIX={{DOCKER_IMAGE_PREFIX}} \
            -e HISTFILE=$WORKSPACE/.tmp/.bash_history \
            -e WORKSPACE=$WORKSPACE \
            -v {{ROOT}}:$WORKSPACE \
            -v $HOME/.gitconfig:/root/.gitconfig \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -w $WORKSPACE \
            {{DOCKER_IMAGE_PREFIX}}cloud:{{DOCKER_TAG}} bash || true

# If the ./app docker image in not build, then build it
@_build_docker:
    if [[ "$(docker images -q {{DOCKER_IMAGE_PREFIX}}cloud:{{DOCKER_TAG}} 2> /dev/null)" == "" ]]; then \
        echo -e "🚪🚪  ➡ {{bold}}Building docker image ...{{normal}} 🚪🚪 "; \
        echo -e "🚪 </> {{bold}}docker build -t {{DOCKER_IMAGE_PREFIX}}cloud:{{DOCKER_TAG}} . {{normal}}🚪 "; \
        docker build -t {{DOCKER_IMAGE_PREFIX}}cloud:{{DOCKER_TAG}} . ; \
    fi

_ensure_inside_docker:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f /.dockerenv ]; then
        echo -e "🌵🔥🌵🔥🌵🔥🌵 Not inside a docker container. First run the command: 'just' 🌵🔥🌵🔥🌵🔥🌵"
        exit 1
    fi
