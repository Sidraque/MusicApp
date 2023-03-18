import SwiftUI

struct PlaylistDetailView: View {
    @State private var isPlaying = false
    @State private var currentProgress: CGFloat = 0.0
    @State var playlist: Playlist
    @State private var showingAddSongPopup = false
    @State private var selectedSongs: [Song] = []
    
    func delete(at offsets: IndexSet) {
        playlist.songs.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: playlist.image!)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .cornerRadius(20)
            
            VStack {
                Text(playlist.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 0)
                Text("By MusicApp")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 0)
            }
            
            Spacer()
            Spacer()
            
            HStack {
                Image(systemName: "shuffle")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    self.isPlaying.toggle()
                }) {
                    if self.isPlaying {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                        if self.isPlaying {
                            self.currentProgress += 0.005
                            if self.currentProgress > 1.0 {
                                self.currentProgress = 0.0
                                self.isPlaying = false
                            }
                        }
                    }
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            .padding(.top, 20)
            .padding(.bottom, 0)
            .overlay(
                GeometryReader { proxy in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.green)
                            .frame(height: 2.0)
                            .frame(width: proxy.size.width * self.currentProgress)
                            .animation(.linear(duration: 0.4))
                    }
                    .frame(height: 8.0)
                }
            )
            .listRowBackground(Color.clear)
            
            Divider()
            
            NavigationLink(destination: MusicView(selectedSongs: $selectedSongs, playlist: $playlist)) {
                Image(systemName: "plus")
            }

            .padding(.bottom, 20)
            .padding(.top, 10)
            .padding(.leading, 300)
            List {
                ForEach(playlist.songs, id: \.self) { song in
                    HStack {
                        Image(song.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .cornerRadius(10)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.name)
                                .font(.headline)
                            Text(song.artist)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: delete)
            }
            
        }
        .padding(.horizontal, 15)
    }
}


struct ProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: 4)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: geometry.size.width * CGFloat(self.progress), height: 4)
            }
        }
    }
}
