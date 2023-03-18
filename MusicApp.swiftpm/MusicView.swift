import SwiftUI

struct Song: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var artist: String
    var image: String
}


let songs = [
    Song(name: "Bad Guy", artist: "Billie Eilish", image: "music1"),
    Song(name: "Blinding Lights", artist: "The Weeknd", image: "music2"),
    Song(name: "Don't Start Now", artist: "Dua Lipa", image: "music3"),
    Song(name: "Levitating", artist: "Dua Lipa", image: "music4"),
    Song(name: "Montero (Call Me By Your Name)", artist: "Lil Nas X", image: "music5"),
    Song(name: "Circles", artist: "Post Malone", image: "music6"),
    Song(name: "Rockstar", artist: "Post Malone ft. 21 Savage", image: "music7"),
    Song(name: "Sunflower", artist: "Post Malone ft. Swae Lee", image: "music8"),
    Song(name: "Dynamite", artist: "BTS", image: "music9"),
    Song(name: "Peaches", artist: "Justin Bieber ft. Daniel Caesar & Giveon", image: "music10"),
    Song(name: "Save Your Tears", artist: "The Weeknd & Ariana Grande", image: "music11"),
    Song(name: "Stay", artist: "The Kid LAROI & Justin Bieber", image: "music12"),
    Song(name: "Good 4 U", artist: "Olivia Rodrigo", image: "music13"),
    Song(name: "Deja Vu", artist: "Olivia Rodrigo", image: "music13"),
    Song(name: "Heartbreak Anniversary", artist: "Giveon", image: "music14"),
    Song(name: "Better Now", artist: "Post Malone", image: "music7"),
    Song(name: "Congratulations", artist: "Post Malone ft. Quavo", image: "music15"),
    Song(name: "Drivers license", artist: "Olivia Rodrigo", image: "music13"),
    Song(name: "Leave The Door Open", artist: "Bruno Mars, Anderson .Paak, Silk Sonic", image: "music16"),
    Song(name: "Industry Baby", artist: "Lil Nas X ft. Jack Harlow", image: "music17")
]

struct MusicView: View {
    @Binding var selectedSongs: [Song]
    @Binding var playlist: Playlist
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.black, .green]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                List(songs, id: \.self) { song in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Toggle(isOn: Binding(
                                get: { selectedSongs.contains(song) },
                                set: { isOn in
                                    if isOn {
                                        selectedSongs.append(song)
                                    } else {
                                        selectedSongs.removeAll(where: { $0 == song })
                                    }
                                }
                            )) {
                                HStack {
                                    Image(song.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(song.name)
                                            .font(.system(size: 18, weight: .medium))
                                        Text(song.artist)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)

                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Músicas")
                .foregroundColor(.white)
                .navigationBarItems(trailing:
                                        Button("Adicionar") {
                    playlist.songs.append(contentsOf: selectedSongs)
                    selectedSongs.removeAll()
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(selectedSongs.isEmpty)
                )
            }
        }
    }
}



//
//
//struct MusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicView()
//    }
//}
