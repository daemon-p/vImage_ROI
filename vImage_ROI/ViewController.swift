//
//  ViewController.swift
//  vImage_ROI
//
//  Created by What on 2020/2/2.
//  Copyright © 2020 dumbass. All rights reserved.
//

import Cocoa
import Accelerate.vImage

class ViewController: NSViewController {

    override var preferredMaximumSize: NSSize {
        .init(width: 100, height: 100)
    }
        
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sourceImage = #imageLiteral(resourceName: "Food_4").cgImage(forProposedRect: nil, context: .current, hints: nil)!
        
        guard var sourceBuffer = try? vImage_Buffer(cgImage: sourceImage) else {
            return
        }
                
        var destinationBuffer = vImage_Buffer()
        
        defer {
            sourceBuffer.free()
        }
        
        vImageBuffer_CropRGBA8888(
            &sourceBuffer,
            &destinationBuffer,
            CGRect(x: 100, y: 100, width: 3000, height: 400))
        
        let format = vImage_CGImageFormat(bitsPerComponent: .init(sourceImage.bitsPerComponent),
                                          bitsPerPixel: .init(sourceImage.bitsPerPixel),
                                          colorSpace: .passUnretained(sourceImage.colorSpace!),
                                          bitmapInfo: sourceImage.bitmapInfo,
                                          version: 0,
                                          decode: sourceImage.decode,
                                          renderingIntent: sourceImage.renderingIntent)
        
        guard let finalImage = try? destinationBuffer.createCGImage(format: format) else {
            return
        }

        imageView.image =  NSImage(cgImage: finalImage,
                                   size: CGSize(width: finalImage.width, height: finalImage.height))
        
    }
}

