import UIKit.UINavigationController

protocol IntroRouterProtocol {
    func navigateToSignup()
    func navigateToSignin()
}

final class IntroRouter: IntroRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToSignup() {
        openWebsite(urlString: "www.cora.com.br")
    }
    
    func navigateToSignin() {
        let authViewController = AuthCPFFactory.create(navigationController: navigationController)
        navigationController.pushViewController(authViewController, animated: true)
    }
    
    private func openWebsite(urlString: String) {
        let formattedURLString = urlString.hasPrefix("http://") || urlString.hasPrefix("https://") ? urlString : "https://\(urlString)"
        guard let url = URL(string: formattedURLString) else {
            print("URL inválida: \(formattedURLString)")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

