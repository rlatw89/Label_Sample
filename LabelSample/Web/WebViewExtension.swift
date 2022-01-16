//
//  WebView.swift
//  LabelSample
//
//  Created by Taewan_MacBook on 2022/01/16.
//

import UIKit
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

extension WebViewController: WKUIDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        debugPrint("JavaScript Alert - \(String(describing: webView.url?.absoluteString))")
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in completionHandler() }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// webview alert confirmation or cancellation delegate
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
      let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)

      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        completionHandler(false)
      }

      let okAction = UIAlertAction(title: "확인", style: .default) { _ in
        completionHandler(true)
      }

      alertController.addAction(cancelAction)
      alertController.addAction(okAction)

      DispatchQueue.main.async {
        self.present(alertController, animated: true, completion: nil)
      }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // open target = "_blank"
        if let frame = navigationAction.targetFrame, frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }
}
