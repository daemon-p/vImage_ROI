//
//  ROI.swift
//  vImage_ROI
//
//  Created by What on 2020/2/2.
//  Copyright © 2020 dumbass. All rights reserved.
//

import Accelerate.vImage

typealias vImageBuffer = UnsafeMutablePointer<vImage_Buffer>

@discardableResult
func vImageBuffer_CropRGBA8888(_ src: vImageBuffer, _ des: vImageBuffer, _ roi: CGRect) -> vImage_Error {
    
    let bufferWidth = Int(src.pointee.width)
    let bufferHeight = Int(src.pointee.height)
        
    let roi = roi.intersection(CGRect(x: 0, y: 0, width: bufferWidth, height: bufferHeight))
    
    let start = Int(roi.minY) * src.pointee.rowBytes + Int(roi.minX) * 4
    
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
