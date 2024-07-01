import SwiftUI
import Lottie
import AVFoundation

struct CustomDialog: View {
    @Binding var isActive: Bool
    let title: String
    let message: String
    let buttonTitle: String
    @State private var offset: CGFloat = 1000
    @Binding var treasureOpen: Bool
    @State private var player3: AVAudioPlayer?
    
    var body: some View {
        ZStack{
            Color(.white)
                .opacity(0.1)
                .onTapGesture {
                    close()
                }
            VStack{
                Text(title)
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                    .padding()
                
                LottieView(animation: .named("Treasure"))
                    .resizable()
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .frame(width: 300, height: 150)
                
                Button {
                    close()
                } label :{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.green)
                        
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay{
                VStack{
                    HStack{
                        Spacer()
                        
                        Button{
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .tint(.black)
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x:0, y:offset)
            .onAppear{
                withAnimation(.spring()){
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func close(){
        withAnimation(.spring()){
            offset = 1000
            isActive = false
            treasureOpen = true
        }
        AudioManager.shared.playSound(named: "companion sound", withExtension: "mp3")
            
    }
    
    class AudioManager {
        static let shared = AudioManager()
        private var player: AVAudioPlayer?

        private init() {}

        func playSound(named: String, withExtension ext: String) {
            guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
                print("Audio file not found")
                return
            }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Audio playback error: \(error)")
            }
        }
    }
}
