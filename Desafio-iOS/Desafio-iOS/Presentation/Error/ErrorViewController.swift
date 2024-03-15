//
//  ErrorViewController.swift
//  Desafio-iOS
//
//  Created by Ana Carolina Martins Pessoa on 14/03/24.
//

import Foundation

import UIKit

final class ErrorViewController: UIViewController {
    private let viewModel: ErrorViewModelProtocol
    private let contentView: ErrorViewProtocol

    init(viewModel: ErrorViewModelProtocol,
         contentView: ErrorViewProtocol = ErrorView()) {
        self.viewModel = viewModel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.actionBack = { [weak self] in
            self?.viewModel.onTapBack()
        }
    }
}
