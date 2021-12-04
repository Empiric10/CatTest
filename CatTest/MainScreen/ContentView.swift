import SwiftUI
import RealmSwift
struct ContentView: View {
    
    let viewModel = CatsViewModel()
    let imageSaver = ImageSaver()
    
    @State private var savedImage = [UIImage]()
    @State private var cats = [String]()
    @StateObject var realmManager = RealmManager()
    @State var isPresented = false
    
    var body: some View {
        VStack{
            List(cats, id: \.self) { item in
                VStack(alignment: .leading) {
                    HStack{
                        AsyncImage(
                            url: URL(string: item)){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 150, height: 150)
                            .padding()
                        VStack{
                            Button("Add to favorites"){
                                realmManager.addCat(url: item)
                                print("Added")
                            }
                            .padding(.vertical)
                            .buttonStyle(.bordered)
                            Button("Save image") {
                                viewModel.saveJpg(item)
                            }
                            .padding(.vertical)
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }.task {
                for _ in 0...4 {
                    await cats.append(viewModel.loadData())
                }
            }
            HStack{
                Button("Load one more cat") {
                    Task(priority: .background) {
                        await cats.append(viewModel.loadData())
                    }
                }.buttonStyle(.bordered)
                    .padding(.horizontal)
                Button("Show favorite cats") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented.toggle()
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.bordered)
                .fullScreenCover(isPresented: $isPresented, content: {
                    FavoriteCatsView(isPresented: $isPresented)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
