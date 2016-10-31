import Foundation

extension Data {

    /// Return hexadecimal string representation of NSData bytes
    public var hexadecimalString: NSString {
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)

        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }

        return NSString(string: hexString)
    }
}
