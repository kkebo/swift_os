@_cdecl("kmain")
public func kmain() {
    initUART()

    print("Hello Swift!")

    repeat { putchar(getchar()) } while true
}
