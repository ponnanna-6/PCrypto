import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(
            action: {
                dismiss() // Dismisses the current view
            },
            label: {
                Image(systemName: "xmark")
                    .font(.headline)
            })
    }
}

#Preview {
    XMarkButton()
}
