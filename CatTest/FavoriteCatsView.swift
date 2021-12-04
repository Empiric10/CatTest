import Foundation
import UIKit
import SwiftUI
import RealmSwift

struct FavoriteCatsView: View {
    
    @Binding var isPresented: Bool
    @StateObject var realmManager = RealmManager()
    
    var body: some View {
        let cats = realmManager.cats
        VStack{
            HStack{
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Back")
                        .font(.system(size: 20))
                })
                    .padding()
                Spacer().frame(alignment: .leading)
                
            }
        }
        Spacer()
        List(cats, id: \.self){ cat in
            HStack{
                AsyncImage(
                    url: URL(string: cat.url)
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 150, height: 150)
                .padding()
                Button("Remove from favorites") {
                    realmManager.deleteFavCat(id: cat.id)
                }
            }
        }
    }
}


struct FavoriteCatsView_Previews: PreviewProvider {
    @State static var isPresented = false
    static var previews: some View {
        FavoriteCatsView(isPresented: $isPresented)
    }
}
