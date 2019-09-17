//
//  MLBusinessDownloadAppView.swift
//  MLBusinessComponents
//
//  Created by Esteban Adrian Boffa on 13/09/2019.
//

import Foundation
import MLUI

@objc open class MLBusinessDownloadAppView: UIView {
    @objc public enum AppSite: Int {
        case ML
        case MP

        internal var getValue: String {
            switch self {
            case .ML: return "MLAppIcon"
            case .MP: return "MPAppIcon"
            }
        }
    }

    private let viewData: MLBusinessDownloadAppData
    private var tapAction: ((_ deepLink: String) -> Void)?

    //Constants
    private let downloadAppViewHeight: CGFloat = 64
    private let appIconImageHeight: CGFloat = 24
    private let appIconImageWidth: CGFloat = 34
    private let downloadButtonHeight: CGFloat = 32
    private let downloadButtonWidth: CGFloat = 112

    public init(_ viewData: MLBusinessDownloadAppData) {
        self.viewData = viewData
        super.init(frame: .zero)
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Privates.
extension MLBusinessDownloadAppView {
    private func render() {
        prepareForAutolayout(UI.Colors.downloadAppViewBackgroundColor)
        layer.cornerRadius = 6
        heightAnchor.constraint(equalToConstant: downloadAppViewHeight).isActive = true

        let appIcon = buildAppIcon()
        let titleLabel = buildTitleLabel(topOf: appIcon)
        let downloadButton = buildDownloadButton(leftTo: titleLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnButton))
        downloadButton.addGestureRecognizer(tapGesture)
    }

    private func buildAppIcon() -> UIImageView {
        let appIcon = UIImageView()
        appIcon.image = MLBusinessResourceManager.shared.getImage(viewData.getAppSite().getValue)
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        appIcon.contentMode = .scaleAspectFit
        self.addSubview(appIcon)
        NSLayoutConstraint.activate([
            appIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            appIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UI.Margin.S_MARGIN),
            appIcon.heightAnchor.constraint(equalToConstant: appIconImageHeight),
            appIcon.widthAnchor.constraint(equalToConstant: appIconImageWidth)
        ])
        return appIcon
    }

    private func buildTitleLabel(topOf targetView: UIView) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.text = viewData.getTitle()
        titleLabel.font = UIFont.ml_lightSystemFont(ofSize: UI.FontSize.XS_FONT)
        titleLabel.applyBusinessLabelStyle()
        titleLabel.numberOfLines = 2
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: targetView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: targetView.rightAnchor, constant: UI.Margin.S_MARGIN)
        ])
        return titleLabel
    }

    private func buildDownloadButton(leftTo targetView: UIView) -> UIButton {
        let downloadButton = UIButton()
        downloadButton.prepareForAutolayout(MLStyleSheetManager.styleSheet.secondaryColor)
        self.addSubview(downloadButton)
        downloadButton.layer.cornerRadius = 5
        downloadButton.setTitle(viewData.getButtonTitle(), for: .normal)
        downloadButton.titleLabel?.font = UIFont.ml_semiboldSystemFont(ofSize: UI.FontSize.XS_FONT)
        NSLayoutConstraint.activate([
            downloadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            downloadButton.leftAnchor.constraint(equalTo: targetView.rightAnchor, constant: UI.Margin.S_MARGIN),
            downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UI.Margin.S_MARGIN),
            downloadButton.heightAnchor.constraint(equalToConstant: downloadButtonHeight),
            downloadButton.widthAnchor.constraint(equalToConstant: downloadButtonWidth)
        ])
        return downloadButton
    }

    // MARK: Tap Selector
    @objc private func didTapOnButton() {
        tapAction?(viewData.getButtonDeepLink())
    }
}

// MARK: Public Methods.
extension MLBusinessDownloadAppView {
    @objc open func addTapAction(_ action: ((_ deepLink: String) -> Void)?) {
        self.tapAction = action
    }
}
