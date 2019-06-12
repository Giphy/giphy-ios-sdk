//
//  ViewController+Keyboard.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/19/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit

extension ViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardDidChangeFrame(notif:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(notif:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(notif:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardChange(notif: NSNotification) {
        guard let frame = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration = notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        let curve = notif.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        textFieldBottomConstraint?.constant = -frame.size.height + view.safeBottomInset - 10
        collectionView.scrollToItem(at: IndexPath(row: conversation.count - 1, section: 0), at: .bottom, animated: true)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {[weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc func keyboardWillShow(notif: NSNotification) {
        handleKeyboardChange(notif: notif)
    }
    @objc func keyboardWillHide(notif: NSNotification) {
        textFieldBottomConstraint?.constant = -10
    }
    @objc func keyboardDidChangeFrame(notif: NSNotification) {
        guard textField.isFirstResponder else { return }
        handleKeyboardChange(notif: notif)
    }
}
