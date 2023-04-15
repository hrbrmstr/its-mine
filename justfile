build:
  swiftc -target x86_64-apple-macosx11.0 -o its-mine-x86_64 its-mine.swift
  swiftc -target arm64-apple-macosx11.0 -o its-mine-arm64 its-mine.swift
  lipo -create -output its-mine its-mine-x86_64 its-mine-arm64
  codesign --force --verify --verbose --sign "${APPLE_DEV_ID}" its-mine

git:
  git add -A && git commit -m "chore: lazy justfile commit" && git push