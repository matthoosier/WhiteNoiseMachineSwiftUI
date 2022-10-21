//
//  AirplayView.swift
//  WhiteNoiseMachineSwiftUI
//
//  Created by Matt Hoosier on 3/26/22.
//

import SwiftUI
import AVKit
import AVFoundation

struct AirplayView: View {
    
    var player: AVPlayer
    
    var body: some View {
        AirPlayView(player: player)
    }
}

struct AirplayView_Previews: PreviewProvider {
    static var previews: some View {
        AirplayView(player: AVPlayer())
    }
}

#if canImport(UIKit)
struct AirPlayView : UIViewRepresentable {
    typealias UIViewType = AVRoutePickerView

    var player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func makeUIView(context: Context) -> AVRoutePickerView {
        let picker = AVRoutePickerView()
        return picker
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
    }
    
}
#else
struct AirPlayView : NSViewRepresentable {

    var player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }

    func makeNSView(context: NSViewRepresentableContext<AirPlayView>) -> NSView {
        let picker = AVRoutePickerView()
        picker.player = player
        return picker
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}
#endif
