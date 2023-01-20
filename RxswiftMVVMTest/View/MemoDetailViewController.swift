//
//  MemoDetailViewController.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var viewModel: MemoDetailViewModel
    let disposeBag = DisposeBag()
    
    
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
        
        deleteButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.deleteBtnTapped.onNext(true)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
//        editButton.rx.tap
//            .subscribe(onNext: {
//                self.viewModel.editBtnTapped.onNext(true)
//            })
//            .disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editMemoVC = segue.destination as? EditMemoViewController else { return }
        editMemoVC.viewModel = self.viewModel
    }
}
