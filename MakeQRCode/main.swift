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
//
//func convertCIImageToCGImage(_ inputImage: CIImage) -> CGImage? {
//	let context = CIContext(options: nil)
//	return context.createCGImage(inputImage, from: inputImage.extent)
//}

extension NSImage {
	var pngData: Data? {
		guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
		return bitmapImage.representation(using: .png, properties: [:])
	}
	
	func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) throws {
		try pngData?.write(to: url, options: options)
	}
}

func makeItSo() {
	guard let url = URL(string: "shoutout://?invitetoken=1234567890abcdefghi") else {
		print("Invalid URL")
		return
	}
	
	let generator = QRCodeGenerator()
	generator.correctionLevel = .H
	generator.backgroundColor = QRColor(calibratedRed: 0.220, green: 0.557, blue: 0.235, alpha: 1.0)
	generator.foregroundColor = QRColor.white
	guard let image = generator.createImage(url: url, size: CGSize(width: 200, height: 200)) else {
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
	
	//	guard var qrCode = QRCode(url) else {
	//		print("Could not generate QRCode from URL")
	//		return
	//	}
	//	qrCode.errorCorrection = .High
	//	qrCode.backgroundColor = CIColor(red: 0.220, green: 0.557, blue: 0.235)
	//	qrCode.color = CIColor.white
	//	qrCode.size = CGSize(width: 400, height: 400)
	//	guard let ciImage = qrCode.ciImage else {
	//		print("Could not generate CoreImage for QRCode")
	//		return
	//	}
	//	guard let cgImage = convertCIImageToCGImage(ciImage) else {
	//		print("Could not generate CoreGraphicsImage for QRCode")
	//		return
	//	}
	//
	//	let cd = FileManager.default.currentDirectoryPath
	//	let fileURL = URL(fileURLWithPath: cd).appendingPathComponent("InviteQRCode.png")
	//
	//	guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypePNG, 1, nil) else {
	//		print("Could not generate image destination")
	//		return
	//	}
	//	CGImageDestinationAddImage(destination, cgImage, nil)
	//	guard CGImageDestinationFinalize(destination) else {
	//		print("Failed to finalise image")
	//		return
	//	}
	//
	//	print("Image was saved to \(fileURL)")
}

makeItSo()
