@_silgen_name("kmain")
public func kmain() {
    initUART()

    print("Hello Swift!")

    repeat { putchar(getchar()) } while true
}
