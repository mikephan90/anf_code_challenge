//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    private var exploreData: [[AnyHashable: Any]]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
         let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
         let jsonDictionary = try? JSONSerialization.jsonObject(with: fileContent, options: .mutableContainers) as? [[AnyHashable: Any]] {
            return jsonDictionary
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreContentCell", for: indexPath)

        if let imageView = cell.viewWithTag(1) as? UIImageView,
           let name = exploreData?[indexPath.row]["backgroundImage"] as? String,
           let image = UIImage(named: name) {
            imageView.image = image
        }
        
        if let topDescriptionLabel = cell.viewWithTag(2) as? UILabel,
           let topDescriptionText = exploreData?[indexPath.row]["topDescription"] as? String {
            topDescriptionLabel.text = topDescriptionText
            topDescriptionLabel.isHidden = false
        }
        
        if let titleLabel = cell.viewWithTag(3) as? UILabel,
           let titleText = exploreData?[indexPath.row]["title"] as? String {
            titleLabel.text = titleText
        }
        
        if let promoLabel = cell.viewWithTag(4) as? UILabel {
            if let promoText = exploreData?[indexPath.row]["promoMessage]"] as? String {
                promoLabel.text = promoText
                promoLabel.isHidden = false
            }
        }
        
        if let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel {
            if let bottomDescriptionText = exploreData?[indexPath.row]["bottomDescription"] as? String {
                let attributedText = labelWithLink(bottomDescriptionText)
                bottomDescriptionLabel.attributedText = attributedText
                bottomDescriptionLabel.isHidden = false

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
                bottomDescriptionLabel.addGestureRecognizer(tapGesture)
                bottomDescriptionLabel.isUserInteractionEnabled = true
            }
        }
        
        if let contentView = cell.viewWithTag(6) {
            if let contentStackView = contentView as? UIStackView {
                
                // Remove existing subviews from contentStackView to prevent additional new views being added
                for subview in contentStackView.arrangedSubviews {
                    contentStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                
                if let content = exploreData?[indexPath.row]["content"] {
                    // Add button component here
                }
            }
        }
        
        return cell
    }
}

extension ANFExploreCardTableViewController {
    
    // Create attribute text from the bottomDescription field in the API response that is pressable
    func labelWithLink(_ bottomDesc: String) -> NSAttributedString {
        do {
            let data = bottomDesc.data(using: .utf8)!
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
            // Center-align the text within the attributed string
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let centeredAttributedString = NSMutableAttributedString(attributedString: attributedString)
            centeredAttributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: centeredAttributedString.length))
            
            return centeredAttributedString
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
        }
        
        return NSAttributedString(string: "")
    }
    
    // Handles bottom description attribute text link
    @objc func handleLinkTap(_ gestureRecognizer: UITapGestureRecognizer) {
       // Add tap link here
    }
}
