const cfg_loader = @import("cfg_loader.zig");
const cfg_checker = @import("cfg_checker.zig");

pub const NAME = "socks";

pub const Config = struct {
    user: [:0]const u8 = "",
    passwd: [:0]const u8 = "",
    ip: []const [:0]const u8 = &.{},
    port: u16 = 1080,
    tcp: bool = true,
    udp: bool = true,

    pub fn load(content: []const u8) ?Config {
        var self = Config{};
        const src = @src();
        cfg_loader.load(src, &self, content) orelse return null;
        cfg_checker.check_ips(src, self.ip) orelse return null;
        cfg_checker.check_port(src, self.port) orelse return null;
        cfg_checker.check_tcp_udp(src, self.tcp, self.udp) orelse return null;
        self.set_default_value();
        return self;
    }

    fn set_default_value(self: *Config) void {
        if (self.ip.len == 0)
            self.ip = opaque {
                const ips = &.{"0.0.0.0"};
            }.ips;
    }
};
