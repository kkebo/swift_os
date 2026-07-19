@_extern(c, "__l1_table")
private nonisolated(unsafe) var l1TableHead: UInt8
@_extern(c, "__l2_table_0")
private nonisolated(unsafe) var l2Table0Head: UInt8
@_extern(c, "__l2_table_1")
private nonisolated(unsafe) var l2Table1Head: UInt8
@_extern(c, "__l2_table_2")
private nonisolated(unsafe) var l2Table2Head: UInt8
@_extern(c, "__l2_table_3")
private nonisolated(unsafe) var l2Table3Head: UInt8

package enum PageTable {
    @_transparent
    package static var l1: UnsafeMutablePointer<UInt> {
        unsafe withUnsafeMutablePointer(to: &l1TableHead) {
            unsafe UnsafeMutableRawPointer($0).bindMemory(to: UInt.self, capacity: 512)
        }
    }
    @_transparent
    package static var l2Table0: UnsafeMutablePointer<UInt> {
        unsafe withUnsafeMutablePointer(to: &l2Table0Head) {
            unsafe UnsafeMutableRawPointer($0).bindMemory(to: UInt.self, capacity: 512)
        }
    }
    @_transparent
    package static var l2Table1: UnsafeMutablePointer<UInt> {
        unsafe withUnsafeMutablePointer(to: &l2Table1Head) {
            unsafe UnsafeMutableRawPointer($0).bindMemory(to: UInt.self, capacity: 512)
        }
    }
    @_transparent
    package static var l2Table2: UnsafeMutablePointer<UInt> {
        unsafe withUnsafeMutablePointer(to: &l2Table2Head) {
            unsafe UnsafeMutableRawPointer($0).bindMemory(to: UInt.self, capacity: 512)
        }
    }
    @_transparent
    package static var l2Table3: UnsafeMutablePointer<UInt> {
        unsafe withUnsafeMutablePointer(to: &l2Table3Head) {
            unsafe UnsafeMutableRawPointer($0).bindMemory(to: UInt.self, capacity: 512)
        }
    }
}
