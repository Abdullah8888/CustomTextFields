//
//  PreviewProvider.swift
//  CustomTextFields
//
//  Created by Abdullah on 27/02/2022.
//

import UIKit

class DummyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct BasePreviewProvider<_view:UIView>: UIViewRepresentable {
    public func makeUIView(context: UIViewRepresentableContext<BasePreviewProvider<_view>>) -> _view {
        return _view()
    }
    
    public func updateUIView(_ uiView: _view, context: UIViewRepresentableContext<BasePreviewProvider<_view>>) {
        
    }
    
    public typealias UIViewType = _view
    public init() {}
        
}


@available(iOS 13.0, *)
struct TestPreviewProvider: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<TestPreviewProvider>) -> DummyView {
        return DummyView()
    }
    
    func updateUIView(_ uiView: DummyView, context: UIViewRepresentableContext<TestPreviewProvider>) {
        
    }
    
    typealias UIViewType = DummyView
    
    
}

@available(iOS 13.0, *)
struct TestPreview: PreviewProvider {
    static var previews: some View {
        TestPreviewProvider()
    }
}

#endif
