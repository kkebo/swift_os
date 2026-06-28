@_disfavoredOverload
func withASCIIBytes<T>(from value: T, _ consumer: (Int, UInt8) -> Void)
where
    T: BinaryInteger & FixedWidthInteger
{
    guard value != 0 else {
        consumer(0, 48)
        return
    }

    var i = 0
    var magnitude = value.magnitude
    var divisor: T.Magnitude = 1

    while magnitude / divisor >= 10 {
        divisor &*= 10
    }

    if value < 0 {
        consumer(i, 45)  // "-"
        i &+= 1
    }

    while divisor != 0 {
        let (q, r) = magnitude.quotientAndRemainder(dividingBy: divisor)
        consumer(i, UInt8(q) &+ 48)
        i &+= 1
        magnitude = r
        divisor /= 10
    }
}

func withASCIIBytes<T>(from value: T, _ consumer: (Int, UInt8) -> Void)
where
    T: UnsignedInteger & FixedWidthInteger
{
    guard value != 0 else {
        consumer(0, 48)
        return
    }

    var i = 0
    var magnitude = value.magnitude
    var divisor: T.Magnitude = 1

    while magnitude / divisor >= 10 {
        divisor &*= 10
    }

    while divisor != 0 {
        let (q, r) = magnitude.quotientAndRemainder(dividingBy: divisor)
        consumer(i, UInt8(q) &+ 48)
        i &+= 1
        magnitude = r
        divisor /= 10
    }
}
