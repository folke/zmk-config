# Use bash for nicer scripting
set shell := ["bash", "-cu"]

# --- Config -------------------------------------------------------------------
ARTIFACT_ZIP   := "firmware.zip"
BUILD_DIR      := "build"
LEFT   := "chocofi_left.uf2"
RIGHT  := "chocofi_right.uf2"
RESET  := "chocofi_settings_reset.uf2"

# --- Helpers ------------------------------------------------------------------

_init:
  @mkdir -p {{BUILD_DIR}}

clean:
  rm -rf {{BUILD_DIR}}

_download id: _init
  #!/bin/env bash
  set -e

  build={{BUILD_DIR}}/firmware_{{id}}

  if [[ ! -d $build ]]; then
    echo "Downloading artifacts for run {{id}}"
    gh run download $id --name firmware --dir $build
  fi

update: _init
  #!/bin/env bash
  set -e

  gh run list --workflow build.yml --limit 1 --json databaseId,conclusion,status > build/status.json

  id=$(jq -r '.[0].databaseId' build/status.json)
  status=$(jq -r '.[0].status' build/status.json)
  conclusion=$(jq -r '.[0].conclusion' build/status.json)
  build={{BUILD_DIR}}/firmware_$id

  echo "Latest run: id=$id status=$status conclusion=$conclusion"

  if [[ "$status" == "completed" ]]; then
    if [[ "$conclusion" == "success" ]]; then
      echo "Build succeeded"
    else
      echo "Build failed"
      exit 1
    fi
  else
    echo "Build is still in progress"
    exit 1
  fi

  just _download $id

flash name: update
  #!/bin/env bash
  set -e

  id=$(jq -r '.[0].databaseId' build/status.json)
  firmware={{BUILD_DIR}}/firmware_$id/chocofi_{{name}}.uf2
  dest=/run/media/$USER/NICENANO/

  if [[ ! -f $firmware ]]; then
    echo "Firmware file $firmware not found!"
    exit 1
  fi

  if [[ ! -d $dest ]]; then
    echo "Device not found at $dest"
    exit 1
  fi

  echo "Flashing $firmware to $dest"
  cp $firmware $dest

right: (flash "right")
left:  (flash "left")
reset: (flash "settings_reset")



