# its-mine

Reclaim your macOS file extension associations.

_(friendlier version + separate GUI app coming soon)_

Signed, universal binary in the releases.

## WAT

- To set default application: `./its-mine set-default <bundleIdentifier> <UTI>`
- To set default applications from a JSON file: `./its-mine set-defaults-json <jsonFilePath>`
- To find UTI for a file extension: `./its-mine find-uti <fileExtension>`
- To find app bundle identifier: `./its-mine find-app <appName>`

## Some example runs:

```bash
./its-mine find-app /Applications/Sublime\ Text.app
Bundle Identifier: com.sublimetext.4
App Path: /Applications/Sublime Text.app
```

```bash
./its-mine find-uti "csv"
UTI for file extension 'csv': public.comma-separated-values-text
```

```bash
 ./its-mine set-default com.sublimetext.4 public.comma-separated-values-text
 Default application set successfully
```

## Something something "set default applications from a JSON file"

`/path/to/your/mappings.json`

```js
[
  { "bundleId": "com.sublimetext.4", "uti": "public.comma-separated-values-text" }
]
```

## Hourly launchd b/c Apple is evil

`~/Library/LaunchAgents/is.rud.its-mine.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>is.rud.its-mine</string>
    <key>ProgramArguments</key>
    <array>
      <string>/path/to/your/its-mine</string>
      <string>set-defaults-json</string>
      <string>/path/to/your/mappings.json</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <true />
  </dict>
</plist>
```

```
launchctl load ~/Library/LaunchAgents/is.rud.its-mine.plist
```

```
launchctl list | grep is.rud.its-mine
```
