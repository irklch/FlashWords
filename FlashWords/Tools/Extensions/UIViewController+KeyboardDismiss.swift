//
//  UIViewController+KeyboardDismiss.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 18.12.2022.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    func setDismissKeyboardTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(setDismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func setDismissKeyboard() {
        view.endEditing(true)
    }
}
