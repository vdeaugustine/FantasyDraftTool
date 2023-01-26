//
//  ExtView.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation
import SwiftUI




extension View {
    func putInRectWithShadow(_ radius: CGFloat = 2) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .shadow(radius: radius)
                .foregroundColor(.white)

            self
        }
    }



    func spacedOut<Content: View>(@ViewBuilder otherView: () -> Content) -> some View {
        HStack {
            self
            Spacer()
            otherView()
        }
    }

    func pushLeft() -> some View {
        spacedOut {
            Spacer()
        }
    }

    
    
//    func `if`<Content: ViewModifier>(_ conditional: Bool, content: Content) -> some View {
//        if conditional {
//            return AnyView(self.modifier(content))
//        } else {
//            return AnyView(self)
//        }
//    }

    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }

    


    func pushTop(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment) {
            self
            Spacer()
        }
    }

    func defaultTextColor() -> some View {
        foregroundColor(Color("DefaultText"))
    }

    var anyView: AnyView {
        AnyView(self)
    }

    func height(_ frameHeight: CGFloat) -> some View {
        frame(height: frameHeight)
    }

    func putInNavView(displayMode: NavigationBarItem.TitleDisplayMode = .automatic) -> some View {
        NavigationView {
            self
                .navigationBarTitleDisplayMode(displayMode)
        }
        .navigationViewStyle(.stack)
    }

    func makeNavLink<Destination: View>(@ViewBuilder destination: () -> Destination) -> some View {
        NavigationLink {
            destination()
        } label: {
            self
        }
    }

    func centerInParentView() -> some View {
        VStack(alignment: .center) {
            self
        }
        .frame(maxWidth: .infinity)
    }

    func toolbarSave(_ execute: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    execute()
                }
            }
        }
    }

    func toolbarKeyboardDone(_ action: (() -> Void)? = nil) -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    action?()
                    hideKeyboard()
                }
            }
        }
    }

    func toolbarAdd<Destination>(@ViewBuilder destination: () -> Destination) -> some View where Destination: View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    destination()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    func allPartsTappable(alignment: Alignment? = nil) -> some View {
        ZStack(alignment: alignment ?? .center) {
            self
            Color.white
                .opacity(0.001)
        }
    }
    


    func toolbarNavigate<Destination>(text: String, @ViewBuilder destination: () -> Destination) -> some View where Destination: View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    destination()
                } label: {
                    Text(text)
                }
            }
        }
    }

    func toolbarButton(_ buttonText: String, _ execute: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(buttonText) {
                    execute()
                }
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func hideNav() -> some View {
        if #available(iOS 16, *) {
            return self.toolbar(.hidden)
        } else {
            return navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
        }
    }

    func optionalPadding(_ condition: Bool) -> AnyView {
        if condition {
            return padding().anyView
        } else {
            return anyView
        }
    }
}

// MARK: - UINavigationController + UIGestureRecognizerDelegate

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
