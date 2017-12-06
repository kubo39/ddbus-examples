import ddbus.thin;
import std.stdio;
import std.typecons : Tuple;

auto sendNotification(Connection conn)
{
    Message msg = Message("org.freedesktop.Notifications",
                          "/org/freedesktop/Notifications",
                          "org.freedesktop.Notifications",
                          "Notify");
    msg.build("Test ddbus App", 0U, "mail-unread",
        "Test", "This is a test of DBus binding for D.",
        ["close", "Close", "open", "Open"],
        DBusAny(["hoge": variant(DBusAny(0))]), 5000);
    Message reply = conn.sendWithReplyBlocking(msg, 2000);
    return reply.read!uint();
}

auto getServerInformation(Connection conn)
{
    alias ServerInformation = Tuple!(string, "name", string, "vendor",
                                 string, "version_", string, "specVersion");
    Message msg = Message("org.freedesktop.Notifications",
                          "/org/freedesktop/Notifications",
                          "org.freedesktop.Notifications",
                          "GetServerInformation");
    Message reply = conn.sendWithReplyBlocking(msg, 2000);
    return reply.readTuple!ServerInformation();
}

string[] getCapabilities(Connection conn)
{
    Message msg = Message("org.freedesktop.Notifications",
                          "/org/freedesktop/Notifications",
                          "org.freedesktop.Notifications",
                          "GetCapabilities");
    Message reply = conn.sendWithReplyBlocking(msg, 2000);
    return reply.read!(string[])();
}

void main()
{
    Connection conn = connectToBus();

    conn.sendNotification();

    conn.getCapabilities().writeln;

    auto serverInformation = conn.getServerInformation();
    writeln(serverInformation.name);
    writeln(serverInformation.vendor);
    writeln(serverInformation.version_);
    writeln(serverInformation.specVersion);
}
