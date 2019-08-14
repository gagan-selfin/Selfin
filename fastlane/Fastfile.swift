// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
    func betaLane() {
        desc("Push a new beta build to TestFlight")
        incrementBuildNumber(xcodeproj: "Selfin.xcodeproj")
        buildApp(workspace: "Selfin.xcworkspace", scheme: "Selfin")
        uploadToTestflight(username: appleID, skipWaitingForBuildProcessing: true)
        uploadSymbolsToCrashlytics(dsymPath: "./Selfin.app.dSYM.zip")
    }
}
