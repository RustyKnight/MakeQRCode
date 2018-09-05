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

func convertCIImageToCGImage(_ inputImage: CIImage) -> CGImage? {
	let context = CIContext(options: nil)
	return context.createCGImage(inputImage, from: inputImage.extent)
}

func makeItSo() {
	guard let url = URL(string: "shoutout://?invitetoken=1234567890abcdefghi") else {
		print("Invalid URL")
		return
	}
	guard var qrCode = QRCode(url) else {
		print("Could not generate QRCode from URL")
		return
	}
	qrCode.errorCorrection = .High
	guard let ciImage = qrCode.ciImage else {
		print("Could not generate CoreImage for QRCode")
		return
	}
	guard let cgImage = convertCIImageToCGImage(ciImage) else {
		print("Could not generate CoreGraphicsImage for QRCode")
		return
	}

	let cd = FileManager.default.currentDirectoryPath
	let fileURL = URL(fileURLWithPath: cd).appendingPathComponent("InviteQRCode.png")

	guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypePNG, 1, nil) else {
		print("Could not generate image destination")
		return
	}
	CGImageDestinationAddImage(destination, cgImage, nil)
	guard CGImageDestinationFinalize(destination) else {
		print("Failed to finalise image")
		return
	}
	
	print("Image was saved to \(fileURL)")
}

makeItSo()
