//
//  Home.swift
//  ColorsPicker
//
//  Created by Skander BAHRI on 02/01/2023.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var currentItem: ColorValue?
    @State var expendCard: Bool = false
    @State var moveCradDown: Bool = false
    
    // MARK: Matched geometry namespace
    @Namespace var animation
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            /// - Extracting SafeArea ( Window n macOS ) from proxy
            let safeArea = proxy.safeAreaInsets
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 8) {
                    ForEach(colors) { color in
                       CardView(item: color, rectSize: size)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            /// Material Top bar
            .safeAreaInset(edge: .top) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: safeArea.top)
                    .overlay {
                        Text("Colors Picker")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .opacity(0.8)
                    }
                    .overlay(alignment: .trailing) {
                        Text("V1.0.0")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.trailing, 8)
                    }
            }
            .ignoresSafeArea(.container, edges: .all)
            .overlay {
                if let currentItem, expendCard {
                    DetailView(item: currentItem, rectSize: size)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 10)))
                }
            }
        }
        .frame(width: 380, height: 500)
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func DetailView(item: ColorValue, rectSize: CGSize) -> some View {
        ColorView(item: item, rectSize: rectSize)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                ColorDetails(item: item, rectSize: rectSize)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.4)) {
                    expendCard = false
                    moveCradDown = false
                }
            }
    }
    
    /// - Reusable Card view
    @ViewBuilder
    func CardView(item: ColorValue, rectSize: CGSize) -> some View {
        let tappedCard = item.id == currentItem?.id && moveCradDown
        /// Multiples view with the same id should be avoided
        if !(item.id == currentItem?.id && expendCard) {
            ColorView(item: item, rectSize: rectSize)
                .overlay(content: {
                    ColorDetails(item: item, rectSize: rectSize)
                })
                .frame(height: 110)
                .contentShape(Rectangle())
                .offset(y: tappedCard ? 30 : 0)
                .zIndex(tappedCard ? 100 : 0)
                .onTapGesture {
                    currentItem = item
                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.4)) {
                        moveCradDown = true
                    }
                    
                    /// - After a little delay starting hero animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                            expendCard = true
                        }
                    }
                }
        } else {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 110)
        }
    }
    
    /// - Reusable Color details
    @ViewBuilder
    func ColorDetails(item: ColorValue, rectSize: CGSize) -> some View {
        HStack {
            Text("#\(item.colorCode)")
                .font(.title.bold())
                .foregroundColor(.white)
                
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Hexadecimal")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: rectSize.width * 0.3, alignment: .leading)
        }
        .padding([.leading, .vertical], 16)
        .matchedGeometryEffect(id: item.id.uuidString + "DETAILS", in: animation)
    }
    
    /// - Reusable Color View
    @ViewBuilder
    func ColorView(item: ColorValue, rectSize: CGSize) -> some View {
        Rectangle()
            .overlay {
                Rectangle()
                    .fill(item.color.gradient)
            }
            .overlay {
                Rectangle()
                    .fill(item.color.opacity(0.5).gradient)
                    .rotationEffect(.init(degrees: 180))
            }
            .matchedGeometryEffect(id: item.id.uuidString, in: animation)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
