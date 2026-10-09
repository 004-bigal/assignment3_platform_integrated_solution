//
//  ShareViewController.swift
//  PlantAppShare
//
//  Created by Alik Orgun on 9/10/2026.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleASharedImage()
    }

    func handleASharedImage() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            dismiss()
            return
        }

        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments where provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] data, _ in
                    defer { self?.dismiss() }
                    guard let url = data as? URL,
                          let groupURL = FileManager.default.containerURL(
                            forSecurityApplicationGroupIdentifier: "group.com.alikorgun.plant2026"
                          ) else { return }

                    let imagesDir = groupURL.appendingPathComponent("shared-images", isDirectory: true)
                    try? FileManager.default.createDirectory(at: imagesDir, withIntermediateDirectories: true)

                    let dest = imagesDir.appendingPathComponent("\(UUID().uuidString).jpg")
                    try? FileManager.default.copyItem(at: url, to: dest)
                }
                return
            }
        }
        dismiss()
    }

    func dismiss() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
