@_silgen_name("kmain")
func kmain() {
    print("Hello Swift!")
}

@usableFromInline
let uart = UnsafeMutablePointer<UInt8>(bitPattern: 0x09000000)!

@inlinable
func putchar(_ c: UInt8) {
    uart[0] = c
}

func print(_ s: StaticString, terminator: StaticString = "\n") {
    s.withUTF8Buffer { buf in
        for c in consume buf {
            putchar(consume c)
        }
    }
    terminator.withUTF8Buffer { buf in
        for c in consume buf {
            putchar(consume c)
        }
    }
}
