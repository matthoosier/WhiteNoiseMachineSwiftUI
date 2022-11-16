//
//  ContentView.swift
//  WhiteNoiseMachineSwiftUI
//
//  Created by Matt Hoosier on 3/26/22.
//

import SwiftUI
import AVKit
import MediaPlayer

extension View {
    func addVerifiedBadge(_ isVerified: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            self

            if isVerified {
                Image(systemName: "checkmark.circle.fill")
                    .offset(x: 3, y: -3)
            }
        }
    }
    
    func addAirplayView(player: AVPlayer) -> some View {
        ZStack(alignment: .bottomTrailing) {
            AirplayView(player: player)
                .frame(width: 50, height: 50)
            self
        }
    }
}

struct ContentView: View {

    @Binding var playerProvider: PlayerProvider
    
    @Binding var playing: Bool
    
    var body: some View {
        ZStack {
            // The big image has on opaque white background, so we'll put
            // a flood-fill of white behind everything else just to match.
            Rectangle()
                .foregroundColor(.clear)
                // Force this rectangle to expand to the size of its
                // parent, which will be determined by the VStack below.
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Image("WhiteNoiseMachine300x292")
                    .padding()
                HStack {
                    Button(action: togglePlaying) {
                        Image(systemName: playing ? "pause.fill" : "play.fill")
                            .accessibilityLabel(playing ? "Pause" : "Play")
                    }
                }
                .font(.largeTitle.weight(.black))
                // Force the button-bar to sop up any extra width or height
                // inherited in the bounding box from its parent.
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .buttonStyle(.borderless)
                .addAirplayView(player: playerProvider.player)
            }
        }
        .fixedSize()
#if os(macOS)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
            
            if let zoomButton = NSApp.mainWindow?.standardWindowButton(.zoomButton) {
                zoomButton.isEnabled = false
                zoomButton.isHidden = false
            }

            if let closeButton = NSApp.mainWindow?.standardWindowButton(.closeButton) {
                closeButton.isEnabled = false
                closeButton.isHidden = false
            }

            if let miniaturizeButton = NSApp.mainWindow?.standardWindowButton(.miniaturizeButton) {
                miniaturizeButton.isEnabled = false
                miniaturizeButton.isHidden = false
            }
        })
#endif
        .onChange(of: playing) {
            newValue in
            if (newValue) {
                play()
#if os(macOS)
                // See https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter/2588243-playbackstate
                MPNowPlayingInfoCenter.default().playbackState = .playing
#endif
            }
            else {
                pause()
#if os(macOS)
                // See https://developer.apple.com/documentation/mediaplayer/mpnowplayinginfocenter/2588243-playbackstate
                MPNowPlayingInfoCenter.default().playbackState = .paused
#endif
            }
        }
        .onAppear {
            setupRemoteTransportProtocols()
        }
        .onDisappear {
            removeRemoteTransportProtocols()
        }
    }

    func togglePlaying() {
        playing.toggle()
    }
    
    func play() {
        playerProvider.player.play()
    }
    
    func pause() {
        playerProvider.player.pause()
    }

    func setupRemoteTransportProtocols() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget(handler: handleCommandCenterPlayCommand)
        commandCenter.pauseCommand.addTarget(handler: handleCommandCenterPauseCommand)
    }

    func removeRemoteTransportProtocols() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(handleCommandCenterPlayCommand)
        commandCenter.pauseCommand.removeTarget(handleCommandCenterPauseCommand)
    }
    
    func handleCommandCenterPlayCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        // property-change handlers will do the heavy work
        playing = true
        return .success
    }
    
    func handleCommandCenterPauseCommand(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        // property-change handlers will do the heavy work
        playing = false
        return .success
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var playing = false
    @State static var playerProvider = PlayerProvider()
    
    static var previews: some View {
        ContentView(playerProvider: $playerProvider, playing: $playing)
    }
}
