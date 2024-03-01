//
//  ChatViewController.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    private let mainView = ChatView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    private func initViewController() {
        setSlideBackFunctionality()
        setupButtons()
    }
}

extension ChatViewController {
    private func setupButtons() {
        mainView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
}

extension ChatViewController {
    @objc 
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    private func setSlideBackFunctionality() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
