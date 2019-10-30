import UIKit
import MarkdownView
import Anchorage
import SafariServices

final class MarkdownPresentationViewController: UIViewController {
    let markdownView = MarkdownView()
    let loading = TableLoadingView()
    
    public func setMarkdown(_ markdown: String) {
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                markdownView.visualMode = .light
            } else {
                markdownView.visualMode = .dark
            }
        } else {
            markdownView.visualMode = .light
        }
        
        view.bringSubviewToFront(loading)
        markdownView.load(markdown: markdown)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(markdownView)
        markdownView.edgeAnchors == view.edgeAnchors
        
        view.addSubview(loading)
        loading.edgeAnchors == view.edgeAnchors
        
        markdownView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "file" {
                return false
            } else if url.scheme == "http" || url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            } else {
                return false
            }
        }
        
        markdownView.onRendered = { [weak self] _ in
            if let `self` = self {
                self.view.sendSubviewToBack(self.loading)
            }
        }
    }
}
