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
    
    var pageTitle = ""
    var pageURL = ""
    
    @IBOutlet var script: UITextView!
    
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
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

    }

    /// send data back to Safari, at wich point it will appear inside finalize( ) funciton
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }

}
