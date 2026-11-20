#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
android_sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
platform="${ANDROID_JAR:-$android_sdk/platforms/android-35/android.jar}"
tools="${ANDROID_BUILD_TOOLS:-$android_sdk/build-tools/35.0.0}"
output="${OBD_OUTPUT_DIR:-$PWD/build}"
mkdir -p "$output"
output="$(cd "$output" && pwd)"
workspace="$(mktemp -d)"
trap 'rm -rf "$workspace"' EXIT
mkdir -p "$workspace/classes" "$workspace/dex" "$workspace/generated"

app="$PWD/app/src/main"
mapfile -t sources < <(find "$app/java" -name '*.java' -type f | sort)
bootclasspath="$platform:$tools/core-lambda-stubs.jar"

"$tools/aapt2" compile --dir "$app/res" -o "$workspace/resources.zip"
"$tools/aapt2" link -I "$platform" --manifest "$app/AndroidManifest.xml" \
  --java "$workspace/generated" -A "$app/assets" -o "$workspace/unsigned.apk" "$workspace/resources.zip"
sources+=("$workspace/generated/rs/kiza/obd/R.java")
if [[ -n "${ECJ_JAR:-}" ]]; then
  java -jar "$ECJ_JAR" -source 8 -target 8 -encoding UTF-8 -nowarn \
    -bootclasspath "$bootclasspath" -d "$workspace/classes" "${sources[@]}"
else
  javac -source 8 -target 8 -encoding UTF-8 -bootclasspath "$bootclasspath" \
    -d "$workspace/classes" "${sources[@]}"
fi
mapfile -t classes < <(find "$workspace/classes" -name '*.class' -type f | sort)
"$tools/d8" --release --min-api 26 --lib "$platform" --output "$workspace/dex" "${classes[@]}"
zip -q -j "$workspace/unsigned.apk" "$workspace/dex/classes.dex"
"$tools/zipalign" -f -p 4 "$workspace/unsigned.apk" "$workspace/aligned.apk"

keystore="${OBD_KEYSTORE:-$output/kiza-obd-test.p12}"
if [[ ! -f "$keystore" ]]; then
  if [[ -n "${OBD_KEYSTORE:-}" ]]; then
    printf 'Keystore does not exist: %s\n' "$keystore" >&2
    exit 1
  fi
  (umask 077; keytool -genkeypair -keystore "$keystore" -storetype PKCS12 \
    -storepass android -alias kiza-obd -keyalg RSA -keysize 2048 \
    -validity 3650 -dname "CN=Kiza OBD Test Build")
fi
export OBD_KEYSTORE_PASSWORD="${OBD_KEYSTORE_PASSWORD:-android}"
"$tools/apksigner" sign --ks "$keystore" --ks-key-alias "${OBD_KEY_ALIAS:-kiza-obd}" \
  --ks-pass env:OBD_KEYSTORE_PASSWORD --out "$output/Kiza-OBD.apk" "$workspace/aligned.apk"
"$tools/apksigner" verify --verbose "$output/Kiza-OBD.apk"
