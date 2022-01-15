//
//  WebView.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/16.
//

import WebKit

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            debugPrint("URL is nil")
            return
        }
        
        let urlString = String(describing: url.absoluteString)
        debugPrint("Decoded URL: \(urlString)")
        
        if !(url.scheme ?? "").contains("http") && UIApplication.shared.canOpenURL(url) {
            loadingIndicator.stopAnimating()
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
        
        if urlString.hasPrefix("http:") {
            let vaildUrlString = urlString.replacingOccurrences(of: "http:", with: "https:")
            webView.load(URLRequest(url: URL(string: vaildUrlString)!))
        }
        
        if urlString == "call://close" {
            self.dismiss(animated: true, completion: nil)
            decisionHandler(.cancel)
            return
        }
        
        else {
            decisionHandler(.allow)
        }
    }
}
