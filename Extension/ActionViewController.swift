//
//  ActionViewController.swift
//  Extension
//
//  Created by Lee Sangoroh on 23/02/2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// extensionContext enables controll on how extension will interact with parent application
        /// inputItems - array of data the parent app is sending to our extension to use
        /// inputItem - array of attachments, wrapped up as an NSItemProvider
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            ///pull out first attachment from first input item
            if let itemProvider = inputItem.attachments?.first {
                /// ask itemProvider to provide the item
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // do stuff!
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
