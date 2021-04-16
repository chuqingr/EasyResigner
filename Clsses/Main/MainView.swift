//
//  MainSignView.swift
//  ResignForiOS
//
//  Created by hanxiaoqing on 2018/1/23.
//  Copyright © 2018年 cheng. All rights reserved.
//


import Foundation
import Cocoa

extension NSPasteboard.PasteboardType {
    public static var kFilenames: NSPasteboard.PasteboardType {
        return self.init("NSFilenamesPboardType")
    }
}

extension NSResponder {
    func parentController<T: NSViewController>(of type: T.Type) -> T? {
        guard let next = self.nextResponder else {
            return nil
        }
        return (next as? T) ?? next.parentController(of: T.self)
    }
}


class MainView : NSView {
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .every
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("performDragOperation")
        let pasteboard = sender.draggingPasteboard
        if let board = pasteboard.propertyList(forType: .kFilenames) as? NSArray {
            if let filePath = board[0] as? String {
                print("dragged file:", filePath)
                let parentController = self.parentController(of: ViewController.self)!
                var isDir: ObjCBool = false
                if FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir) {
                    if isDir.boolValue {
                        if filePath.hasSuffix(".app") || filePath.hasSuffix(".APP") || filePath.hasSuffix(".xcarchive") {
                            parentController.inputFileField.stringValue = filePath
                        }
                    }else {
                        if filePath.hasSuffix(".ipa") || filePath.hasSuffix(".IPA") {
                            parentController.inputFileField.stringValue = filePath
                        }
                        
                    }
                } else {
                    return false
                }
                return true
            }
        }
        return false
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([.kFilenames])    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([.kFilenames])
    }
}
