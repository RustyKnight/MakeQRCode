//
//  main.swift
//  MakeQRCode
//
//  Created by Shane Whitehead on 5/9/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage
import Cocoa

extension NSImage {
	var pngData: Data? {
		guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
		return bitmapImage.representation(using: .png, properties: [:])
	}
	
	func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) throws {
		try pngData?.write(to: url, options: options)
	}
}

func makeQRCode() {
//	guard let url = URL(string: "your url text") else {
//		print("Invalid URL")
//		return
//	}
	
	let generator = QRCodeGenerator()
	generator.correctionLevel = .H
	generator.backgroundColor = QRColor(calibratedRed: 0.220, green: 0.557, blue: 0.235, alpha: 1.0)
	generator.foregroundColor = QRColor.white
//	guard let image = generator.createImage(url: url, size: CGSize(width: 200, height: 200)) else {
//		return
//	}
    guard let image = generator.createImage(value: "the value of your QR code", size: CGSize(width: 200, height: 200)) else {
        print("Could not generate QR code")
        return
    }
	
	let cd = FileManager.default.currentDirectoryPath
	let fileURL = URL(fileURLWithPath: cd).appendingPathComponent("InviteQRCode.png")
	do {
		try image.pngWrite(to: fileURL)
		print("Image was written to \(fileURL)")
	} catch let error {
		print("Failed to write image: \(error)")
	}
}

makeQRCode()
