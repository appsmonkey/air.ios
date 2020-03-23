//
//  SplashViewController.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 20/11/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
  lazy var backgroundImage: UIImageView = {
    let imageView: UIImageView
    imageView = UIImageView(frame: self.view.bounds)
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = UIImage(named: "launch-bg")
    imageView.center = self.view.center
    return imageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

  func setupViews() {
    self.view.addSubview(backgroundImage)

    backgroundImage.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
