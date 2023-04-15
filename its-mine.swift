import Cocoa
import CoreServices
import UniformTypeIdentifiers
import Foundation

struct AppMapping: Codable {
	let bundleId: String
	let uti: String
}

func processJSONFile(jsonPath: String) {
	let url = URL(fileURLWithPath: jsonPath)
	do {
		let data = try Data(contentsOf: url)
		let decoder = JSONDecoder()
		let appMappings = try decoder.decode([AppMapping].self, from: data)
		
		for mapping in appMappings {
			let status = setDefaultApplication(bundleIdentifier: mapping.bundleId, forUTI: mapping.uti)
			if status == noErr {
				print("Default application set successfully for UTI '\(mapping.uti)' with bundle ID '\(mapping.bundleId)'")
			} else {
				print("Failed to set default application for UTI '\(mapping.uti)' with bundle ID '\(mapping.bundleId)'. Error code: \(status)")
			}
		}
	} catch {
		print("Error reading or processing the JSON file: \(error.localizedDescription)")
	}
}

func setDefaultApplication(bundleIdentifier: String, forUTI uti: String) -> OSStatus {
	
  guard let bundleID = bundleIdentifier as CFString?,
    let type = uti as CFString?
  else {
    return errSecParam
  }

  let status = LSSetDefaultRoleHandlerForContentType(type, LSRolesMask.all, bundleID)
  return status

}

func findAppBundleIdentifier(appPath: String) -> String? {
  let appURL = URL(fileURLWithPath: appPath)

  if let bundle = Bundle(url: appURL) {
    return bundle.bundleIdentifier
  }

  return nil
}

func findUTI(forFileExtension fileExtension: String) -> String? {
	let uti = UTType(tag: fileExtension, tagClass: .filenameExtension, conformingTo: nil)
	return uti?.identifier
}

let args = CommandLine.arguments

if args.count < 3 {
  print("Usage:")
	print("To set default applications from a JSON file: \(args[0]) set-defaults-json <jsonFilePath>")
  print("To find UTI for a file extension: \(args[0]) find-uti <fileExtension>")
  print("To set default application: \(args[0]) set-default <bundleIdentifier> <UTI>")
  print("To find app bundle identifier: \(args[0]) find-app <appName>")
  exit(1)
}

let command = args[1]

if command == "set-default", args.count == 4 {

  let bundleIdentifier = args[2]
  let uti = args[3]
  let status = setDefaultApplication(bundleIdentifier: bundleIdentifier, forUTI: uti)

  if status == noErr {
    print("Default application set successfully")
  } else {
    print("Failed to set default application. Error code: \(status)")
  }

} else if command == "find-app", args.count == 3 {

  let appPath = args[2]
  if let bndl = findAppBundleIdentifier(appPath: appPath) {
    print("Bundle Identifier: \(bndl)")
    print("App Path: \(appPath)")
  } else {
    print("App not found")
  }

} else if command == "find-uti" && args.count == 3 {

	let fileExtension = args[2]
	if let uti = findUTI(forFileExtension: fileExtension) {
		print("UTI for file extension '\(fileExtension)': \(uti)")
	} else {
		print("Unable to find UTI for file extension '\(fileExtension)'")
	}
	
}else if command == "set-defaults-json" && args.count == 3 {

	let jsonFilePath = args[2]
	processJSONFile(jsonPath: jsonFilePath)

} else {

  print("Invalid command or arguments")
  exit(1)

}
