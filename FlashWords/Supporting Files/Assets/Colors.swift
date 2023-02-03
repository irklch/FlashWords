// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let hex000000 = ColorAsset(name: "hex000000")
  internal static let hex1D1C21 = ColorAsset(name: "hex1D1C21")
  internal static let hex2E2C32 = ColorAsset(name: "hex2E2C32")
  internal static let hex333337 = ColorAsset(name: "hex333337")
  internal static let hex424247 = ColorAsset(name: "hex424247")
  internal static let hex5E5E69 = ColorAsset(name: "hex5E5E69")
  internal static let hex6ECDCC = ColorAsset(name: "hex6ECDCC")
  internal static let hex7A7A7E = ColorAsset(name: "hex7A7A7E")
  internal static let hexCD626F = ColorAsset(name: "hexCD626F")
  internal static let hexD5BAFE = ColorAsset(name: "hexD5BAFE")
  internal static let hexF09937 = ColorAsset(name: "hexF09937")
  internal static let hexF2F2F2 = ColorAsset(name: "hexF2F2F2")
  internal static let hexF3C196 = ColorAsset(name: "hexF3C196")
  internal static let hexFCFCFC = ColorAsset(name: "hexFCFCFC")
  internal static let hexFFADAE = ColorAsset(name: "hexFFADAE")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
