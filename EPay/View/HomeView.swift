//
//  HomeView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/22/24.
//

import SwiftUI

// VisualEffectView: A wrapper to use UIVisualEffectView from UIKit in SwiftUI.
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    // Creates the UIVisualEffectView with the specified effect.
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    // Updates the effect of the existing UIVisualEffectView when needed.
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

struct AccountCardView: View {
    var account: Account
    var body: some View {
        
        let colorPool: [Color] = [.blue, .green, .indigo, .mint, .orange, .pink, .red, .teal, .yellow]
        
        // create a new shuffled array of colorPool and take the first 3 after shuffled
        let colors = colorPool.shuffled().prefix(3)
        
        ZStack {
            RadialGradient(colors: [colors[0], colors[0].opacity(0)], center: .topTrailing, startRadius: 0, endRadius: 300)
            RadialGradient(colors: [colors[1], colors[1].opacity(0)], center: .topLeading, startRadius: 0, endRadius: 300)
            RadialGradient(colors: [colors[2], colors[2].opacity(0)], center: .bottomLeading, startRadius: 0, endRadius: 300)
            
            // Applied Blur effects over gradient
            VisualEffectView(effect: UIBlurEffect(style: .regular)).edgesIgnoringSafeArea(.all)
            
            // Account details
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
        .shadow(color: Color.black.opacity(0.2), radius: 5,x: 0,y: 2) // Adding depth to cards
        .shadow(color: Color.pink.opacity(0.3), radius: 20,x: 0,y: 10)
    }
}

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel // Access user data
    @State var isExpand: Bool = false // check if it expand or not

    var totalBalance: String {
        let totalCents = userModel.currentUser?.accounts.reduce(0) { $0 + $1.balance } ?? 0
        let totalDollars = Double(totalCents) / 100.0
        return String(format: "$%.2f", totalDollars)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 20)
                HStack {
                    Text("EPay")
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
                .frame(width: 390, height: 25)

                VStack {
                    Text("Total Balance")
                        .foregroundColor(.white)
                        .font(.system(size: 13)).bold()
                    
                    Text(totalBalance)
                        .foregroundColor(.white)
                        .font(.system(size: 30)).bold()
                }
                .frame(width:390 ,height: 100)
    
                // Scroll vertically and don't show the scroll bar
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: isExpand ? 20 : -150) { // spacing between each card
                        // if currentUser exist go to accounts else nil if accounts nil then
                        // return empty array`
                        ForEach(userModel.currentUser?.accounts ?? [], id: \.id) { account in
                            AccountCardView(account: account)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        isExpand.toggle() // change state of isExpand
                                    } // each tap isExpand turn true tap again false
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


