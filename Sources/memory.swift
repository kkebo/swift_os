// FIXME: It shouldn't be needed.
@_silgen_name("swift_release")
public func swift_release(object: UnsafeMutablePointer<HeapObject>?) {
    swift_release_n_(object: object, n: 1)
}
