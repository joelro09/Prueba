//
//  CustomTextField.swift
//  Prueba
//
//  Created by Joel Ramírez on 19/02/23.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UIView {
    
    @IBInspectable
    var placeHolder: String = "Contraseña"{
        didSet{
            textField.placeholder = placeHolder
        }
    }
    @IBInspectable
    var maxLength:Int = 50
    
    /// Delegado para los texFields personalizados
    var delegate: CustomTextFieldDelegate?
    @IBInspectable
    var errorMessage: String = " "{
        didSet{
            errorLabel.text = errorMessage
        }
    }
    
    var haveAnError = false
    
 
    var style: TextFieldStyle = .password {
        didSet{
            switch style {
            case .normal:
                errorLabel.isHidden = false
                errorLabel.text = " "
                //rightButton.isHidden = true
            case .password:
                //rightButton.isHidden = false
                isSecureTextEntry = true
                errorLabel.isHidden = false
                rightButton.isUserInteractionEnabled = true
                rightButton.setImage(#imageLiteral(resourceName: "password_hide"), for: .normal)
                rightButton.addTarget(self, action: #selector(toggleSegurity), for: .touchUpInside)
            case .error,.number:
                errorLabel.isHidden = false
                errorLabel.text = " "
            }
        }
    }
    
    private var isSecureTextEntry = false{
        didSet{
            textField.isSecureTextEntry = isSecureTextEntry
            let image = isSecureTextEntry ? #imageLiteral(resourceName: "password_hide"):#imageLiteral(resourceName: "password_show")
            rightButton.setImage(image, for: .normal)
        }
    }
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    lazy var tfInnerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = errorMessage
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    lazy var tfContainer: ShadowView = {
        let view = ShadowView()
        view.borderWidth = 1
        view.borderColor = .lightGray
        view.cornerRadius = 6
        view.backgroundColor = .white
        return view
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = placeHolder
        tf.tintColor = .red
        tf.isSecureTextEntry = isSecureTextEntry
        return tf
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        //button.setImage(#imageLiteral(resourceName: "password_hide"), for: .normal)
        button.setTitle("", for: .normal)
        button.isUserInteractionEnabled = false
        button.tintColor = .red
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    
    
    @objc func toggleSegurity() {
        isSecureTextEntry.toggle()
    }
    
    func getText() -> String?{
         textField.text
    }
    
    func setError(message: String?){
        if let mes = message{
            errorMessage = mes
            errorLabel.isHidden = false
            tfContainer.borderColor = .red
            haveAnError = true
        }else{
            errorMessage = " "
            errorLabel.isHidden = false
            tfContainer.borderColor = .lightGray
            haveAnError = false
        }
       
    }
    
    func validateTextField(type: TextValidation) -> Bool{
        if getText()?.isValidData(validType: type) ?? false{
            return true
        }else{
            return false
        }
    }
    
    
    
}

extension CustomTextField: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if style == .number{
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                        return false
                    }
                    return count <= maxLength
            }
        
        if style == .normal{
            guard CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁáéÉíÍÓúÚ ").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
                return count <= maxLength
        }
        
        
            return count <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setError(message: nil)
    }
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        setError(message: nil)
    }*/
    
}

protocol CustomTextFieldDelegate {
    func textFieldShouldReturn(_ textField: CustomTextField) -> Bool
    func textFieldDidEndEditing(_ textField: CustomTextField)
}


enum TextFieldStyle{
    case normal
    case password
    case error
    case number
}

enum TextValidation: String{
    case mail = "^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$"
    case password = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,16}$"
    case digit = ".{8,16}$"
    case upperLetter = "^(.*[A-Z].*)"
    case lowerLetter = "^(.*[a-z].*)"
    case number = "^(.*\\d.*)"
}

extension String{
    func isValidData(validType: TextValidation) -> Bool{
        return validType.rawValue.validateData(textToValidate: self)
    }
    
    func validateData(textToValidate: String) -> Bool{
        let p = NSPredicate(format: "SELF MATCHES %@", self)
        return p.evaluate(with: textToValidate)
    }

}
