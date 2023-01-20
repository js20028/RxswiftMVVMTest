//
//  EditMemoViewController.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2023/01/13.
//

import UIKit
import RxSwift
import RxCocoa

class EditMemoViewController: UIViewController {
    
    static let identifier = "EditMemoViewController"

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    let disposeBag = DisposeBag()
    var viewModel: MemoDetailViewModel
    
    init(viewModel: MemoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = MemoDetailViewModel()
        super.init(coder: coder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()

    }
    
    func bindUI() {
        
        viewModel.titleText
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.contentText
            .bind(to: contentsTextView.rx.text)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .debug()
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
        
        contentsTextView.rx.text.orEmpty
            .debug()
            .bind(to: viewModel.contentText)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.editMemo()
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
