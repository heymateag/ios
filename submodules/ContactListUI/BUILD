load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

load("@build_bazel_rules_apple//apple:apple.bzl",
    "apple_dynamic_framework_import",
    "apple_static_framework_import")


apple_static_framework_import(
  name = "PaymateFramework",
  framework_imports = glob(["MobileRTC.framework/**","Paysubframework.framework/**"]),
  visibility = ["//visibility:public"],
)

apple_static_framework_import(
  name = "PromiseKitFramework",
  framework_imports = glob(["PromiseKit.framework/**"]),
  visibility = ["//visibility:public"],
)

apple_static_framework_import(
  name = "MicroblinkFramework",
  framework_imports = glob(["Microblink.framework/**"]),
  visibility = ["//visibility:public"],
)

apple_static_framework_import(
  name = "PassbaseFramework",
  framework_imports = glob(["Passbase.framework/**"]),
  visibility = ["//visibility:public"],
)

objc_library(
    name = "PaymateSDK",
    deps = [
        ":PaymateFramework",
        ":PromiseKitFramework",
        ":MicroblinkFramework",
        ":PassbaseFramework",
    ]
)


swift_library(
    name = "ContactListUI",
    module_name = "ContactListUI",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    deps = [
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
        "//submodules/AsyncDisplayKit:AsyncDisplayKit",
        "//submodules/Display:Display",
        "//submodules/TelegramCore:TelegramCore",
        "//submodules/TelegramPresentationData:TelegramPresentationData",
        "//submodules/AccountContext:AccountContext",
        "//submodules/TelegramUIPreferences:TelegramUIPreferences",
        "//submodules/MergeLists:MergeLists",
        "//submodules/SearchUI:SearchUI",
        "//submodules/ChatListSearchItemHeader:ChatListSearchItemHeader",
        "//submodules/ItemListPeerItem:ItemListPeerItem",
        "//submodules/ContactsPeerItem:ContactsPeerItem",
        "//submodules/ChatListSearchItemNode:ChatListSearchItemNode",
        "//submodules/TelegramPermissionsUI:TelegramPermissionsUI",
        "//submodules/TelegramNotices:TelegramNotices",
        "//submodules/AlertUI:AlertUI",
        "//submodules/PresentationDataUtils:PresentationDataUtils",
        "//submodules/ShareController:ShareController",
        "//submodules/AppBundle:AppBundle",
        "//submodules/OverlayStatusController:OverlayStatusController",
        "//submodules/PhoneNumberFormat:PhoneNumberFormat",
        "//submodules/SolidRoundedButtonNode:SolidRoundedButtonNode",
        "//submodules/StickerResources:StickerResources",
        "//submodules/AnimatedStickerNode:AnimatedStickerNode",
        "//submodules/TelegramAnimatedStickerNode:TelegramAnimatedStickerNode",
	    ":PaymateSDK",
    ],
    visibility = [
        "//visibility:public",
    ],
)
