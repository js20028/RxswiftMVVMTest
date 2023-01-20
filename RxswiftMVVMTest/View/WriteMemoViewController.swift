//
//  WriteMemoViewController.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class WriteMemoViewController: UIViewController {
    
    static let identifier = "WriteMemoViewController"
    
    var viewModel: WriteMemoViewModel
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var registerButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    init(viewModel: WriteMemoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = WriteMemoViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
    }
    
    func bindUI() {
        titleTextField.rx.text.orEmpty
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
        
        contentsTextView.rx.text.orEmpty
            .bind(to: viewModel.contentText)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.isTitleValid, viewModel.isContentValid) { $0 && $1 }
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive(onNext: {
                // 수정할것
                self.viewModel.addMemo()
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
