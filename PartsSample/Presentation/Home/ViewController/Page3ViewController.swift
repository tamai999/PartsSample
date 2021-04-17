//
//  Page3ViewController.swift
//  PartsSample
//

import UIKit

class Page3ViewController: PageViewController {
    
    // MARK: - private properties
    
    private let stackView = UIStackView()
    private let artView1 = ShaderArtView()
    private let artView2 = ShaderArtView()
    private let artView3 = ShaderArtView()
    private let artView4 = ShaderArtView()
    private let artView5 = ShaderArtView()
    private let artView6 = ShaderArtView()
    private let artView7 = ShaderArtView()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
}

// MARK: - private

private extension Page3ViewController {
    
    func setupView() {
        view.addSubview(stackView)
        artView1.setupView(shaderName: "taptapShader")
        stackView.addArrangedSubview(artView1)
        artView2.setupView(shaderName: "circleShader")
        stackView.addArrangedSubview(artView2)
        artView3.setupView(shaderName: "waveShader", imageName: "sampleImage")
        stackView.addArrangedSubview(artView3)
        artView4.setupView(shaderName: "kaiteiShader")
        stackView.addArrangedSubview(artView4)
        artView5.setupView(shaderName: "auroraShader")
        stackView.addArrangedSubview(artView5)
        artView6.setupView(shaderName: "skeletonShader")
        stackView.addArrangedSubview(artView6)
        artView7.setupView(shaderName: "starBaseShader")
        stackView.addArrangedSubview(artView7)
    }
    
    func setupLayout() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        artView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView4.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView5.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView6.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        artView7.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
}
