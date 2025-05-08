import SwiftUI
import RealityKit

struct SpaceWindowView: View {
    let task: TaskItem
    @Binding var isPresented: Bool
    @Binding var currentCardIndex: Int
    @StateObject private var taskManager = TaskManager.shared
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(taskManager.tasks[0].title)  // Always show first task
                        .font(.title2).bold()
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 4) {
                        Text(taskManager.tasks[0].date.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(taskManager.tasks[0].startTime.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    // Labels together in a wrapping frame
                    VStack(alignment: .leading, spacing: 8) {
                        if !taskManager.tasks[0].location.isEmpty {
                            Label {
                                Text(taskManager.tasks[0].location)
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
                        if !taskManager.tasks[0].tag.isEmpty {
                            Label {
                                Text(taskManager.tasks[0].tag)
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
                    Button(action: {
                        isPresented = false
                    }) {
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
    SpaceWindowView(
        task: TaskItem(
            title: "Sample Task",
            description: "This is a sample task",
            location: "Sample Location",
            tag: "Sample Tag",
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            type: .task
        ),
        isPresented: .constant(true),
        currentCardIndex: .constant(0)
    )
}
