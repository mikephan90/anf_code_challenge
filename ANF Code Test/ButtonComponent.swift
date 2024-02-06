//
//  ButtonComponent.swift
//  ANF Code Test
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit

struct ButtonModel {
    let targetURL: String
    let title: String
}

class ButtonComponent {

    static func createButton(with buttonModel: ButtonModel, indexPath: IndexPath, target: Any?, action: Selector?) -> UIButton {
        let button = UIButton(type: .system)

        // Button properties/customizations
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36).isActive = true
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        button.setTitle(buttonModel.title, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)

        if let action = action, let target = target {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        button.tag = indexPath.row

        return button
    }

    // Button action on tap to open hyperlink
    static func handleContentButtonTap(_ sender: UIButton, target: Any?, exploreData: [ExploreDataResponse]?) {
       // add button functionality here
    }
}
