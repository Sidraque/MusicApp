import SwiftUI
import UIKit

struct Playlist: Codable {
    var name: String
    var songs: [Song]
    var imageData: Data?
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    init(name: String, songs: [Song], image: UIImage?) {
        self.name = name
        self.songs = songs
        self.imageData = image?.jpegData(compressionQuality: 1.0)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, songs, imageData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        songs = try container.decode([Song].self, forKey: .songs)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(songs, forKey: .songs)
        try container.encodeIfPresent(imageData, forKey: .imageData)
    }
}


struct PlaylistView: View {
    @State var playlists: [Playlist]
    
    @State private var isShowingAddPlaylistPopup = false
    
    func delete(at offsets: IndexSet) {
        playlists.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(playlists, id: \.name) { playlist in
                    NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                        HStack {
                            Image(uiImage: playlist.image!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .cornerRadius(10)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(playlist.name)
                                    .font(.headline)
                            }
                            Spacer()
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Playlists")
            .navigationBarItems(trailing:
                                    Button(action: {
                isShowingAddPlaylistPopup = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $isShowingAddPlaylistPopup) {
                AddPlaylistView(playlist: $playlists, isShowingAddPlaylistPopup: $isShowingAddPlaylistPopup)
            }
        }
    }
}

struct AddPlaylistView: View {
    @Binding var playlist: [Playlist]
    @State private var newPlaylistName = ""
    @State private var newPlaylistImage: UIImage?
    @Binding var isShowingAddPlaylistPopup: Bool
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Playlist Nome")) {
                    TextField("Nome", text: $newPlaylistName)
                }
                
                Section(header: Text("Playlist Imagem")) {
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Escolha a Imagem")
                    }
                    if let image = newPlaylistImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                }
            }
            .navigationBarTitle("Adicionar Playlist")
            .navigationBarItems(
                leading: Button(action: {
                    self.isShowingAddPlaylistPopup = false
                }) {
                    Text("Cancelar")
                },
                trailing: Button(action: {
                    let newPlaylist = Playlist(name: newPlaylistName, songs: [], image: newPlaylistImage!)
                    playlist.append(newPlaylist)
                    self.isShowingAddPlaylistPopup = false
                }) {
                    Text("Salvar")
                }.disabled(newPlaylistName.isEmpty || newPlaylistImage == nil)
            )
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$newPlaylistImage)
        }
    }
    
    func loadImage() {
        guard let selectedImage = newPlaylistImage else { return }
        newPlaylistImage = selectedImage
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ContentView: View {
    @State var playlists: [Playlist] = []
    
    var body: some View {
        PlaylistView(playlists: playlists)
    }
}
