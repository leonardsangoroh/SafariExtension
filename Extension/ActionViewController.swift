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
        
        /// register as an observer for a notification (need reference to the default notification center)
        let notificationCenter = NotificationCenter.default
        /// addObserver (object to receive notification, method to be called, notifications we want to receive, object we want to watch)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

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
    
    /// receive parameter of type Notification
    @objc func adjustForKeyboard(notification: Notification) {
        /// UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating.
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        /// convert rectangle to view's coordinates
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        /// adjust content inset and scroll indicators insets
        if notification.name == UIResponder.keyboardWillHideNotification {
            /// if external keyboard is added
            script.contentInset = .zero
        } else {
            /// adjust content inset and scroll indicators insets
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        /// make text view scroll for the text entry cursor to be visible
        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
