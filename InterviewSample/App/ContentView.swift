import SwiftUI

struct ContentView: View {
    
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            SearchView(viewModel: SearchViewModel())
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .artist(let media):
                        ArtistView(viewModel: ArtistViewModel(artist: media))
                    }
                }
        }
        .sheet(item: $coordinator.showSong) { song in
            PlayerView(viewModel: PlayerViewModel(media: song))
        }
        .alert("Common.DevelopmentAlert", isPresented: $coordinator.showDevelopmentAlert) {
            Button(role: .cancel) {
                // nothing to do here
            } label: {
                Text("Common.OK")
            }
        }
        .environmentObject(coordinator)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
