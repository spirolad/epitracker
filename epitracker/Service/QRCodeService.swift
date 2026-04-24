import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeService {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    func generate(from courseID: Int64) -> UIImage {
        let data = Data(String(courseID).utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {

            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
