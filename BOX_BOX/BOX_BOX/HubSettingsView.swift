import SwiftUI

struct HubSettingsView: View {
    let hub: Hub

    var body: some View {
        Form {
            Section("Hub status") {
                LabeledContent("Connection", value: "Connected")
                LabeledContent("Battery", value: "\(hub.battery ?? 0)%")
            }
        }
        .navigationTitle(hub.name)
    }
}
