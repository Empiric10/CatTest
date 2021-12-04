import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    
    private(set) var localRealm: Realm?
    @Published var cats: [FavoriteCats] = []
    
    init() {
        openRealm()
        getFavCats()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    // Do something, usually updating the schema's variables here
                }
            })

            Realm.Configuration.defaultConfiguration = config

            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func addCat(url: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let savedCat = FavoriteCats()
                    savedCat.id = Int.random(in: 0...100)
                    savedCat.url = url
                    localRealm.add(savedCat)
                    print("Added new cat to Realm!")
                }
            } catch {
                print("Error adding cat to Realm", error)
            }
        }
    }
    
    func getFavCats() {
        if let localRealm = localRealm {
            let allCats = localRealm.objects(FavoriteCats.self)
            allCats.forEach { savedCat in
                cats.append(savedCat)
            }
        }
    }
    
    
    func deleteFavCat(id: Int) {
        if let localRealm = localRealm {
            let allCats = localRealm.objects(FavoriteCats.self)
            let cat = allCats.filter("id == \(id)")
            guard !cat.isEmpty else { return }

            do {
                try localRealm.write {
                    localRealm.delete(cat)
                    cats = []
                    getFavCats()
                    print("Cat deleted from Realm")
                }
            } catch {
                print("Error deleting cat", error)
            }

        }
    }
    
}
