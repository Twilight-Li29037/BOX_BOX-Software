import SwiftUI

struct HubSettingsView: View {
    let hub: Hub
    let connectedDevices: [Device]
    @State private var connectionCapacity: ConnectionCapacity = .oneToFive

    var body: some View {
        Form {
            Section("Hub status") {
                LabeledContent("Connection", value: "Connected")
                LabeledContent("Battery", value: "\(hub.battery ?? 0)%")
            }

            Section("Connected devices") {
                ForEach(connectedDevices) { device in
                    NavigationLink {
                        DeviceDetailView(device: device)
                    } label: {
                        HStack {
                            Text(device.name)
                            Spacer()
                            Text(device.distance.map { String(format: "%.1f m", $0) } ?? "—")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section {
                NavigationLink {
                    ConnectionCapacityView(selectedCapacity: $connectionCapacity)
                } label: {
                    LabeledContent("Choose connection capacity", value: connectionCapacity.rawValue)
                }
            }
        }
        .navigationTitle(hub.name)
    }
}

private enum ConnectionCapacity: String, CaseIterable, Identifiable {
    case oneToFive = "1-5"
    case fiveToTen = "5-10"
    case tenToFifteen = "10-15"

    var id: Self { self }
}

private struct ConnectionCapacityView: View {
    @Binding var selectedCapacity: ConnectionCapacity

    var body: some View {
        List {
            Section("Connection capacity") {
                ForEach(ConnectionCapacity.allCases) { capacity in
                    Button {
                        selectedCapacity = capacity
                    } label: {
                        HStack {
                            Text(capacity.rawValue)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedCapacity == capacity {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
            }

            Section {
                Button("Reset") {
                    selectedCapacity = .oneToFive
                }
            }
        }
        .navigationTitle("Connection capacity")
    }
}
