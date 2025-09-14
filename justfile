# Use bash for nicer scripting
set shell := ["bash", "-cu"]

# --- Config -------------------------------------------------------------------
BUILD_DIR      := "build"
SETUP := '
  set -e
  function fail() {
    echo "❌ $1"
    exit 1
  }
'

# --- Helpers ------------------------------------------------------------------

default: status

status:
  @gh run list --workflow build.yml --limit 5

clean:
  rm -rf {{BUILD_DIR}}

update:
  #!/bin/env bash
  {{SETUP}}

  mkdir -p {{BUILD_DIR}}
  gh run list --workflow build.yml --limit 1 --json databaseId,conclusion,status > {{BUILD_DIR}}/status.json

  id=$(jq -r '.[0].databaseId' build/status.json)
  status=$(jq -r '.[0].status' build/status.json)
  conclusion=$(jq -r '.[0].conclusion' build/status.json)
  build={{BUILD_DIR}}/firmware_$id


  if [[ "$status" == "completed" ]]; then
    if [[ "$conclusion" != "success" ]]; then
      fail "Build failed with '$conclusion'"
    fi
  else
    fail "Build not completed"
  fi

  if [[ ! -d $build ]]; then
    echo "Downloading artifacts for run $id"
    gh run download $id --name firmware --dir $build
  fi

  echo "✅ Latest build is ready in $build"

_flash name: update
  #!/bin/env bash
  {{SETUP}}

  id=$(jq -r '.[0].databaseId' build/status.json)
  firmware={{BUILD_DIR}}/firmware_$id/chocofi_{{name}}.uf2
  dest=/run/media/$USER/NICENANO/

  [[ -f $firmware ]] || fail "Firmware file $firmware not found!"
  [[ -d $dest ]] || fail "Device not found at $dest"

  echo "Flashing $firmware to $dest"

  cp $firmware $dest

  echo "✅ Flash complete!"

right: (_flash "right")
left:  (_flash "left")
reset: (_flash "settings_reset")

svg:
  #!/bin/env bash
  {{SETUP}}

  keymap -c svg/config.yml parse -z config/corne.keymap > svg/corne.yaml
  keymap -c svg/config.yml draw -k chocofi -l LAYOUT svg/corne.yaml > svg/corne.svg



