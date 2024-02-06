//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit
import SDWebImage

class ANFExploreCardTableViewController: UITableViewController {
    
    var exploreDataViewModel: ExploreDataViewModel!
    
    var exploreData: [ExploreDataResponse]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreDataViewModel = ExploreDataViewModel()
        
        fetchData {}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreContentCell", for: indexPath)
        
        if let currentData = exploreData?[indexPath.row],
           let imageView = cell.viewWithTag(1) as? UIImageView,
           let imageUrl = URL(string: currentData.backgroundImage) {
            imageView.contentMode = .scaleAspectFit
            
            // Using SDWeb Image to asyncronously pull from the API call and make updates
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage")) { (image, error, _, _) in
                if let error = error {
                    print("Error loading image: \(error)")
                } else if let image = image {
                    // Adjusts image size
                    let aspectRatio = image.size.width / image.size.height
                    let maxWidth: CGFloat = self.view.bounds.width
                    
                    let newWidth = min(maxWidth, image.size.width)
                    let newHeight = newWidth / aspectRatio
                    
                    imageView.image = image
                    imageView.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
                }
            }
            
            if let topDescriptionLabel = cell.viewWithTag(2) as? UILabel,
               let topDescriptionText = currentData.topDescription {
                topDescriptionLabel.text = topDescriptionText
                topDescriptionLabel.isHidden = false
            }
            
            if let titleLabel = cell.viewWithTag(3) as? UILabel {
                titleLabel.text = currentData.title
            }
            
            if let promoLabel = cell.viewWithTag(4) as? UILabel {
                if let promoText = currentData.promoMessage {
                    promoLabel.text = promoText
                    promoLabel.isHidden = false
                }
            }
            
            // Not too excited about this implementation - I would extract the text and link out
            // separately to have better testability here
            if let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel {
                if let bottomDescriptionText = currentData.bottomDescription {
                    let attributedText = labelWithLink(bottomDescriptionText)
                    bottomDescriptionLabel.attributedText = attributedText
                    bottomDescriptionLabel.isHidden = false
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
                    bottomDescriptionLabel.addGestureRecognizer(tapGesture)
                    bottomDescriptionLabel.isUserInteractionEnabled = true
                }
            }
            
            // create the button 'content' with links
            if let contentView = cell.viewWithTag(6) {
                if let contentStackView = contentView as? UIStackView {
                    
                    // Remove existing subviews from contentStackView to prevent additional new views being added
                    for subview in contentStackView.arrangedSubviews {
                        contentStackView.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                        contentStackView.spacing = 8
                    }
                    
                    if let content = currentData.content {
                        for contentItem in content {
                            let buttonModel = ButtonModel(targetURL: contentItem.target, title: contentItem.title)
                            let button = ButtonComponent.createButton(with: buttonModel, indexPath: indexPath, target: self, action: #selector(handleContentButtonTap(_:)))
                            contentStackView.addArrangedSubview(button)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func fetchData(completion: @escaping () -> Void) {
        exploreDataViewModel.fetchData { result in
            switch result {
            case .success(var data):
                self.exploreData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    completion()
                }
            case .failure(let error):
                print(error)
                completion()
            }
        }
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
        if let label = gestureRecognizer.view as? UILabel,
           let attributedText = label.attributedText,
           let link = attributedText.attribute(.link, at: gestureRecognizer.charIndex(in: label), effectiveRange: nil) as? URL {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    // Handle the button taps for the content buttons
    @objc func handleContentButtonTap(_ sender: UIButton) {
        ButtonComponent.handleContentButtonTap(sender, target: self, exploreData: exploreData)
    }
}

// Helper function for the attributed text at the location of the link
private extension UITapGestureRecognizer {
    func charIndex(in label: UILabel) -> Int {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString())
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let location = self.location(in: label)
        return layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    }
}
