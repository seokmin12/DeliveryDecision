//
//  ContentView.swift
//  DeliveryDecision
//
//  Created by 이석민 on 2022/09/05.
//

import SwiftUI

class SelectedMenu: ObservableObject {
    @Published var selected_menu: [String] = []
    @Published var icons: [String] = []
    
    init() {
        self.icons = ["치킨", "짜장면", "보쌈", "초밥", "피자", "떡볶이", "햄버거", "한식", "카페", "파스타", "샌드위치", "도시락", "족발"]
    }
}

struct MenuView: View {
    let icon_name: String
    @State private var isAnimated = false
    
    @EnvironmentObject var SelectedMenuList: SelectedMenu
    
    func getImage(named: String) -> Image {
       let uiImage =  (UIImage(named: named) ?? UIImage(named: "menu_null"))!
       return Image(uiImage: uiImage)
    }
    
    var animation: Animation {
        Animation.easeOut
    }
    
    @State private var flip: Bool = false
    
    var body: some View {
        VStack {
            if flip {
                Image("check")
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                Text(icon_name)
                    .foregroundColor(.white)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                getImage(named: icon_name).padding()
                Text(icon_name)
                .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            AngularGradient(gradient: Gradient(colors: [Color(hex: "4776E6"), Color(hex: "#8E54E9")]), center: .topLeading, angle: .degrees(180 + 45))
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4), radius: 15, x: 10, y: 10)
        .shadow(color: .white, radius: 15, x: -10, y: -10)
        .onTapGesture(perform: {
            withAnimation {
                flip.toggle()
            }
            
            if flip == false {
                if let index = SelectedMenuList.selected_menu.firstIndex(of: icon_name) {
                    self.SelectedMenuList.selected_menu.remove(at: index)
                }
            } else {
                self.SelectedMenuList.selected_menu.insert(icon_name, at: 0)
            }
        })
        .rotation3DEffect(.degrees(flip ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}

struct MenuFooterView: View {
    @EnvironmentObject var SelectedMenuList: SelectedMenu
    @State private var MoveRandom = false
    
    var body: some View {
        NavigationLink(destination: RandomDecisionView(SelectedMenu: SelectedMenuList.selected_menu), isActive: $MoveRandom, label: {
            HStack(spacing: 0) {
                Text("\(self.SelectedMenuList.selected_menu.count)개")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "1D1B68"))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.4), radius: 15, x: 10, y: 10)
            .shadow(color: .white, radius: 15, x: -10, y: -10)
        })
        .onTapGesture(perform: {
            MoveRandom = true
        })
    }
}

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium(), .large()]
            presentation.prefersGrabberVisible = true
            presentation.largestUndimmedDetentIdentifier = .medium
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var SelectedMenuList: SelectedMenu
    
    @State private var AddMenuName = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            TextField("추가할 메뉴명", text: $AddMenuName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button("추가하기") {
                SelectedMenuList.icons.append(AddMenuName)
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
        }
    }
}

struct ContentView: View {
    @State private var isAnimated = false
    @State private var isShowingSheet = false
    
    var GridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    @StateObject var SelectedMenuList: SelectedMenu
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("지금 뭐 먹지?")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        isShowingSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.purple)
                    })
                    .sheet(isPresented: $isShowingSheet) {
                        HalfSheet {
                            SheetView(SelectedMenuList: SelectedMenuList)
                        }
                    }
                }
                .padding()
                ScrollView(.vertical) {
                    LazyVGrid(columns: GridLayout, spacing: 40, content: {
                        ForEach(SelectedMenuList.icons, id: \.self) {icon_name in
                            MenuView(icon_name: icon_name)
                        }
                    })
                    .padding()
                }
                MenuFooterView()
                    .padding()
            }
            .edgesIgnoringSafeArea(.all)
            .padding()
            .environmentObject(SelectedMenu())
            .navigationBarHidden(true)
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(SelectedMenuList: SelectedMenu())
        }
    }
}


