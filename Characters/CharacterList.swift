import SwiftUI

struct CharacterList: View {
    
    @State var characters = [MarvelCharacter]()
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("Characters")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getCharacters() {
        let networkManager = NetworkManager()
        
        networkManager.getCharacters(offset: 0, limit: 100) { container, error in
            
            guard let container = container, let characters = container.results, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.characters = characters
            }
        }
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList(characters: MarvelCharacter.characters)
    }
}
