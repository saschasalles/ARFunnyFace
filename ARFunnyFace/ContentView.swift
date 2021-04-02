import SwiftUI
import RealityKit
import ARKit


var arView: ARView!
struct ContentView: View {
  @State var propId: Int = 0

  var body: some View {
    ZStack(alignment: .bottom) {
      ARViewContainer(propId: $propId).edgesIgnoringSafeArea(.all)
      HStack(spacing: 60) {
        Button(action: {
          self.propId = self.propId <= 0 ? 0 : self.propId - 1
        }) {
          Image(systemName: "chevron.left")
            .font(Font.system(size: 45))
            .foregroundColor(.yellow)
        }
        Button(action: {
          self.TakeSnapshot()
        }) {
          Image(systemName: "largecircle.fill.circle")
            .font(Font.system(size: 60))
            .foregroundColor(.yellow)
        }
        Button(action: {
          self.propId = self.propId >= 2 ? 2 : self.propId + 1
        }) {
          Image(systemName: "chevron.right")
            .font(Font.system(size: 45))
            .foregroundColor(.yellow)
        }
      }
    }
  }

  func TakeSnapshot() {
    arView.snapshot(saveToHDR: false) { (image) in
      let compressedImage = UIImage(data: (image?.pngData())!)
      UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  @Binding var propId: Int

  func makeUIView(context: Context) -> ARView {
    arView = ARView(frame: .zero)
    return arView
  }

  func updateUIView(_ uiView: ARView, context: Context) {
    arView.scene.anchors.removeAll()
    let arConfiguration = ARFaceTrackingConfiguration()
    uiView.session.run(arConfiguration, options: [.resetTracking, .removeExistingAnchors])


    switch(propId) {
      case 0:
        let arAnchor = try! Experience.loadEyes()
        uiView.scene.anchors.append(arAnchor)
        break

      case 1:
        let arAnchor = try! Experience.loadGlasses()
        uiView.scene.anchors.append(arAnchor)
        break

      case 2:
        let arAnchor = try! Experience.loadMustache()
        uiView.scene.anchors.append(arAnchor)
        break

      default:
        break
    }
  }

}

#if DEBUG
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
#endif
