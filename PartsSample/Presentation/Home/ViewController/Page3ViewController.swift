//
//  Page3ViewController.swift
//  PartsSample
//

import UIKit

class Page3ViewController: PageViewController {
    
    // MARK: - private properties
    
    private let stackView = UIStackView()
    private weak var artView1: ShaderArtView!
    private weak var artView2: ShaderArtView!
    private weak var artView3: ShaderArtView!
    private weak var artView4: ShaderArtView!
    private weak var artView5: ShaderArtView!
    private weak var artView6: ShaderArtView!
    private weak var artView7: ShaderArtView!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
}

// MARK: - private

private extension Page3ViewController {
    
    func setupViews() {
        view.addSubview(stackView)
        let artView1 = ShaderArtView()
        artView1.setupView(shaderName: "taptapShader")
        stackView.addArrangedSubview(artView1)
        self.artView1 = artView1
        
        let artView2 = ShaderArtView()
        artView2.setupView(shaderName: "circleShader")
        stackView.addArrangedSubview(artView2)
        self.artView2 = artView2
        
        let artView3 = ShaderArtView()
        artView3.setupView(shaderName: "waveShader", imageName: "sampleImage")
        stackView.addArrangedSubview(artView3)
        self.artView3 = artView3
        
        let artView4 = ShaderArtView()
        artView4.setupView(shaderName: "kaiteiShader")
        stackView.addArrangedSubview(artView4)
        self.artView4 = artView4
        
        let artView5 = ShaderArtView()
        artView5.setupView(shaderName: "auroraShader")
        stackView.addArrangedSubview(artView5)
        self.artView5 = artView5
        
        let artView6 = ShaderArtView()
        artView6.setupView(shaderName: "skeletonShader")
        stackView.addArrangedSubview(artView6)
        self.artView6 = artView6
        
        let artView7 = ShaderArtView()
        artView7.setupView(shaderName: "starBaseShader")
        stackView.addArrangedSubview(artView7)
        self.artView7 = artView7
    }
    
    func layoutViews() {
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
