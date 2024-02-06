//
//  HomeView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/22/24.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

struct AccountCardView: View {
    var account: Account
    var body: some View {
        // Using a predefined set of colors
        let colorPool: [Color] = [.blue, .green, .indigo, .mint, .orange, .pink, .red, .teal, .yellow]
        let colors = colorPool.shuffled().prefix(3)
        
        ZStack {
            RadialGradient(colors: [colors[0], colors[0].opacity(0)], center: .topTrailing, startRadius: 0, endRadius: 300)
            RadialGradient(colors: [colors[1], colors[1].opacity(0)], center: .topLeading, startRadius: 0, endRadius: 300)
            RadialGradient(colors: [colors[2], colors[2].opacity(0)], center: .bottomLeading, startRadius: 0, endRadius: 300)
            
            VisualEffectView(effect: UIBlurEffect(style: .regular)).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text(account.name)
                        .font(.system(size: 18)).bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(account.balanceString())
                        .font(.system(size: 18)).bold()
                        .foregroundColor(.white)
                }
                .padding([.top, .horizontal])
                
                Spacer() // Pushes the HStack to the top
            }
        }
        .frame(width: 343, height: 216)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @State var expandCards: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Wallet")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    
                }
                .frame(width: 390, height: 80)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: expandCards ? 20 : -150) {
                        ForEach(userModel.currentUser?.accounts ?? [], id: \.id) { account in
                            AccountCardView(account: account)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        expandCards.toggle()
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
        }
    }
}


#Preview {
    HomeView().environmentObject(UserModel())
}


