import SwiftUI

struct DeviceDetailView: View {
    let device: Device
    @State private var alertDistance = 3.0
    @State private var soundAndHapticsEnabled = true

    var body: some View {
        Form {
            Section("Controls") {
                LabeledContent(
                    "Current distance",
                    value: device.distance.map { String(format: "%.1f m", $0) } ?? "Not available"
                )
                LabeledContent("Battery", value: "\(device.battery)%")
            }

            Section("Alarm distance") {
                Slider(value: $alertDistance, in: 1...10, step: 0.5)
                LabeledContent("Alert farther than", value: String(format: "%.1f m", alertDistance))
            }

            Section {
                Toggle("Haptics | Sound", isOn: $soundAndHapticsEnabled)
            }

            Section("Connection") {
                Button("Find this device") { }
                Button("Disconnect") { }
                Button("Forget device", role: .destructive) { }
                Button("Report issue") { }
            }
        }
        .navigationTitle(device.name)
    }
}
