import ProjectDescription

let project = Project(
    name: "TalkPick",
    packages: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.9.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.0"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.21.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "TalkPick",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.TalkPick",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "GIDClientID": "613623896854-8ngku5ptb32oio9kjpnmpeck9iedgtfv.apps.googleusercontent.com",
                ]
            ),
            sources: ["TalkPick/Sources/**"],
            resources: ["TalkPick/Resources/**"],
            dependencies: [
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "SnapKit"),
                .package(product: "Alamofire"),
                .package(product: "KakaoSDKCommon"),
                .package(product: "KakaoSDKAuth"),
                .package(product: "KakaoSDKUser"),
                .package(product: "Kingfisher"),
                .package(product: "GoogleSignIn")
            ]
        )
    ]
)
