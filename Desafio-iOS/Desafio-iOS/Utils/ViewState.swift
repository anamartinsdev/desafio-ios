import Foundation

enum ViewState<T> {
    case loading
    case error(String)
    case data(T)
}
