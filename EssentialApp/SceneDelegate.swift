//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Khushnidjon on 17/05/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: remoteFeedLoader,
            imageLoader: remoteImageLoader
        )
        
        window?.rootViewController = UINavigationController(rootViewController: feedViewController)
    }
}
