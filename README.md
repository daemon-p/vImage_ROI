# vImage_ROI
- ### Crop image with ROI(BGRA8888)
	
	- Core implementation
		- Validate roi
		- Calculate pixels in roi
		- Fill pixels in desBuffer

			```
			typealias vImageBuffer = UnsafeMutablePointer<vImage_Buffer>
	
		 	@discardableResult
			func vImageBuffer_CropRGBA8888(_ src: vImageBuffer, _ des: vImageBuffer, _ roi: CGRect) -> vImage_Error {
	
		    let bufferWidth = Int(src.pointee.width)
		    let bufferHeight = Int(src.pointee.height)
	
	        /// validate roi
	   		let roi = roi.intersection(CGRect(x: 0, y: 0, width: bufferWidth, height: bufferHeight))
	
	   		/// calculate pixels in roi
	   		/// start: ths first pixel at the topleft in roi
	   		let bytesPerPixel = 4
		    let start = Int(roi.minY) * src.pointee.rowBytes + Int(roi.minX) * bytesPerPixel
	
	    	/// fill pixels in desBuffer
	    	/// WARNING: the image data shared between srcBuffer and desBuffer, NOT COPY
	    	/// so we should call `free(srcBuffer.data) only`
	   		defer {
	       	    des.pointee.rowBytes = src.pointee.rowBytes
	       	    des.pointee.data = src.pointee.data.advanced(by: start)
	    	}
	    
	    	return vImageBuffer_Init(des,
		                      .init(roi.height),
		                      .init(roi.width),
		                      32,
		                      .init(kvImageNoFlags))
		    
			}
	
			```
	
	- Create `srcBuffer/desBuffer`

		```
		let sourceImage = #imageLiteral(resourceName: "Food_4").cgImage(forProposedRect: nil, context: .current, hints: nil)!
        
        guard var sourceBuffer = try? vImage_Buffer(cgImage: sourceImage) else {
            return
        }
        
        var destinationBuffer = vImage_Buffer()

		```
		
	- Call `crop`
		
		```
		vImageBuffer_CropRGBA8888(
            &sourceBuffer,
            &destinationBuffer,
            CGRect(x: 100, y: 100, width: 3000, height: 400))
		
		```
		
	- Display/Validate
	
		```
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
		
		```

	- free memory

		```
		defer {
           sourceBuffer.free()
           /// DO NOT CALL 
           // destinationBuffer.free()
        }
		```
