import SwiftUI

// MARK: - Setup
// Add LOGO.JPG to Assets.xcassets in Xcode and name the image "BOXBOXLogo".
// Then replace the generated ContentView.swift in a new SwiftUI iOS App project
// with this file. Keep the generated <YourProjectName>App.swift file unchanged.

struct ContentView: View {
    @State private var selectedTab: SideTab = .profile
    @State private var activeSheet: ActiveSheet?
    @State private var selectedDeviceID: Device.ID?
    @State private var deviceToShow: Device?
    @State private var hubToShow: Hub?
    @State private var devices = [
        Device(name: "Camera Bag", distance: 1.2, battery: 86, isConnected: true),
        Device(name: "Keys", distance: 3.8, battery: 72, isConnected: true),
        Device(name: "Laptop Sleeve", distance: nil, battery: 44, isConnected: false)
    ]
    private let hubs = [
        Hub(name: "Watch Hub", battery: 84, isConnected: true),
        Hub(name: "Square Hub", battery: nil, isConnected: false)
    ]

    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                SideBar(selectedTab: $selectedTab)
                    .frame(width: 76)

                Divider()

                VStack(spacing: 0) {
                    header
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 22)

                    Divider()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            devicesSection
                            Divider()
                            hubSettingsCard
                            aboutCard
                        }
                        .padding(24)
                    }
                }
            }
            .background(Color(uiColor: .systemBackground))
            .navigationDestination(item: $deviceToShow) { device in
                DeviceDetailView(device: device)
            }
            .navigationDestination(item: $hubToShow) { hub in
                HubSettingsView(hub: hub)
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .about:
                AboutBOXBOXView()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome to")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
            Text("BOX BOX")
                .font(.largeTitle.bold())
        }
    }

    private var devicesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("My devices")
                    .font(.title2.bold())
                Spacer()
                Button {
                    devices.append(Device(name: "New BOX BOX Tag", distance: nil, battery: 100, isConnected: true))
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                }
            }

            Picker("Select a device", selection: $selectedDeviceID) {
                ForEach(devices) { device in
                    Text(device.name).tag(Optional(device.id))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .clipped()
            .onAppear {
                selectedDeviceID = selectedDeviceID ?? devices.first?.id
            }

            if let device = selectedDevice {
                Button {
                    deviceToShow = device
                } label: {
                    DeviceSelectionCard(device: device)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Opens details for \(device.name)")
            }
        }
    }

    private var selectedDevice: Device? {
        devices.first { $0.id == selectedDeviceID } ?? devices.first
    }

    private var hubSettingsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hub settings")
                .font(.title2.bold())

            VStack(spacing: 10) {
                ForEach(hubs) { hub in
                    if hub.isConnected {
                        Button {
                            hubToShow = hub
                        } label: {
                            HubRow(hub: hub)
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens settings for \(hub.name)")
                    } else {
                        HubRow(hub: hub)
                            .opacity(0.42)
                            .accessibilityHint("\(hub.name) is offline")
                    }
                }
            }
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
        }
    }

    private var aboutCard: some View {
        Button {
            activeSheet = .about
        } label: {
            HStack(spacing: 16) {
                Image("BOXBOXLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text("About us")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("Learn more about BOX BOX")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens About us")
    }
}

private struct SideBar: View {
    @Binding var selectedTab: SideTab

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                SideBarButton(tab: .profile, icon: "person.fill", selectedTab: $selectedTab)
                SideBarButton(tab: .settings, icon: "gearshape.fill", selectedTab: $selectedTab)
                SideBarButton(tab: .help, icon: "questionmark.circle.fill", selectedTab: $selectedTab)
            }
            .padding(.top, 18)

            Spacer()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

private struct SideBarButton: View {
    let tab: SideTab
    let icon: String
    @Binding var selectedTab: SideTab

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 44, height: 44)
                .foregroundStyle(selectedTab == tab ? .white : .primary)
                .background(selectedTab == tab ? Color.accentColor : Color.clear,
                            in: RoundedRectangle(cornerRadius: 14))
        }
        .accessibilityLabel(tab.label)
    }
}

private struct DeviceSelectionCard: View {
    let device: Device

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(device.isConnected ? Color.green : Color.gray)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 3) {
                Text(device.name)
                    .font(.body.weight(.semibold))
                Text(device.isConnected ? "Connected · \(device.battery)% battery" : "Offline · \(device.battery)% battery")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(device.distance.map { String(format: "%.1f m", $0) } ?? "—")
                .font(.body.monospacedDigit().weight(.semibold))
                .foregroundStyle(device.isConnected ? .primary : .secondary)

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct HubRow: View {
    let hub: Hub

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(hub.name)
                    .font(.headline)
                    .foregroundStyle(hub.isConnected ? .primary : .secondary)
                Text(hub.isConnected ? "Connected" : "Offline")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(hub.battery.map { "\($0)%" } ?? "—")
                .font(.body.monospacedDigit().weight(.semibold))
                .foregroundStyle(hub.isConnected ? .primary : .secondary)
            if hub.isConnected {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(hub.isConnected ? Color(uiColor: .systemBackground) : Color.clear,
                    in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct AboutBOXBOXView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("BOXBOXLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                Text("BOX BOX")
                    .font(.largeTitle.bold())
                Text("Keep the things that matter within reach.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 36)
                Spacer()
            }
            .padding(.top, 48)
            .navigationTitle("About us")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct Device: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var distance: Double?
    var battery: Int
    var isConnected: Bool
}

struct Hub: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var battery: Int?
    var isConnected: Bool
}

private enum SideTab {
    case profile, settings, help

    var label: String {
        switch self {
        case .profile: "Profile"
        case .settings: "Settings"
        case .help: "Help"
        }
    }
}

private enum ActiveSheet: Identifiable {
    case about

    var id: String {
        switch self {
        case .about: "about"
        }
    }
}

#Preview {
    ContentView()
}
