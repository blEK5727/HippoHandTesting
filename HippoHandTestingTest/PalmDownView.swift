import SwiftUI
import RealityKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct PalmDownView: View {
    let task: TaskItem
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.title2).bold()
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 4) {
                        Text(task.date.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(task.startTime.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    // Labels together in a wrapping frame
                    VStack(alignment: .leading, spacing: 8) {
                        if !task.location.isEmpty {
                            Label {
                                Text(task.location)
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        if !task.tag.isEmpty {
                            Label {
                                Text(task.tag)
                                .font(.subheadline)
                            } icon: {
                                Image(systemName: "tag")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 244/255, green: 243/255, blue: 255/255))
                            .foregroundColor(Color(red: 148/255, green: 133/255, blue: 255/255))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .frame(maxWidth: 320, alignment: .leading)
                }
                Spacer()
                VStack {
                    Button(action: {}) {
                        Text("Edit")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                    .padding(0)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .frame(width: 0, height: 0)
                    .buttonStyle(.plain)
                }
            }
            .padding(30)
            .frame(width: 360, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    PalmDownView(task: TaskItem(
        title: "Pick up Nicole from School",
        description: "",
        location: "Lombardo High School",
        tag: "Family",
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        type: .task
    ))
}
