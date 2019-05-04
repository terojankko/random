//
//  ViewController.swift
//  MVVMTest
//
//  Created by Tero Jankko on 4/12/19.
//  Copyright © 2019 Tero Jankko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var user = User(name: Observable("Frank"))
    
    @IBOutlet weak var username: BoundTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.bind(to: user.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.user.name.value = "Updated name!"
        }
    }
}

struct User {
    var name: Observable<String>
}

class Observable<ObservedType> {
    
    var valueChanged: ((ObservedType?) -> ())?
    
    private var _value: ObservedType?
    
    init(_ value: ObservedType) {
        _value = value
    }
    
    public var value: ObservedType? {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    func bindingChanged(to newValue: ObservedType) {
        _value = newValue
        print("Value is now \(newValue)")
    }
}

class BoundTextField: UITextField {
    
    var changedClosure: (() -> ())?
    
    @objc func valueChanged() {
        changedClosure?()
    }
    
    func bind(to observable: Observable<String>) {
        addTarget(self, action:
            #selector(BoundTextField.valueChanged), for: .editingChanged)
        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
}


