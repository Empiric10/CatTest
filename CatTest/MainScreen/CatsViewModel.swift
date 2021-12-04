import Foundation
import UIKit

class CatsViewModel {
        
    func loadData() async -> String {
        var cat = ""
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            print("Invalid URL")
            return ""
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Cats].self, from: data) {
                
            cat = decodedResponse[0].url
            }
        } catch {
            print("Invalid data")
        }
        return cat
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func saveJpg(_ url: String) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(url)
                DispatchQueue.main.async { /// execute on main thread
                   let savedImage = UIImage(data: data)
                    if let jpgData = savedImage?.jpegData(compressionQuality: 0.5),
                       let path = self.documentDirectoryPath()?.appendingPathComponent("exampleJpg.jpg") {
                        try? jpgData.write(to: path)
                    }
                }
            }
            task.resume()
        }
        

    }
    

}
