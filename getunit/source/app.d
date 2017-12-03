import ddbus.c_lib; // DBusBusType
import ddbus.thin;
import std.stdio;

void main()
{
    Connection conn = connectToBus(DBusBusType.DBUS_BUS_SYSTEM);

    // Get ObjectPath by service name.
    Message msg1 = Message("org.freedesktop.systemd1",
                          "/org/freedesktop/systemd1",
                          "org.freedesktop.systemd1.Manager",
                          "GetUnit");
    msg1.build("docker.service");
    Message reply1 = conn.sendWithReplyBlocking(msg1, 2000);
    auto objectPath = reply1.read!ObjectPath();
    objectPath.writeln;

    // Get active state of the service.
    Message msg2 = Message("org.freedesktop.systemd1",
                           objectPath.toString,
                           "org.freedesktop.DBus.Properties",
                           "Get");
    msg2.build("org.freedesktop.systemd1.Unit", "ActiveState");
    Message reply2 = conn.sendWithReplyBlocking(msg2, 2000);
    reply2.read!string().writeln;
}
