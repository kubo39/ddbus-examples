import ddbus.thin;
import std.stdio;
import std.typecons : Tuple;

alias Notification = Tuple!(string, "appName", uint, "replacesID",
                            string, "appIcon", string, "summary",
                            string, "body_", string[], "actions",
                            DBusAny, "hints", int, "expireTimeout");

uint sendNotification(Connection conn, Notification n)
{
    Message msg = Message("org.freedesktop.Notifications",
                          "/org/freedesktop/Notifications",
                          "org.freedesktop.Notifications",
                          "Notify");
    msg.build(n.expand);
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

    Notification notify;
    notify.appName = "Test ddbus App";
    notify.replacesID = 0;
    notify.appIcon = "mail-unread";
    notify.summary = "Test";
    notify.body_ = "This is a test of DBus binding for D.";
    notify.actions = ["close", "Close", "open", "Open"];
    notify.hints = DBusAny(["hoge": variant(DBusAny(0))]);
    notify.expireTimeout = 5000;
    conn.sendNotification(notify);

    conn.getCapabilities().writeln;

    auto serverInformation = conn.getServerInformation();
    writeln(serverInformation.name);
    writeln(serverInformation.vendor);
    writeln(serverInformation.version_);
    writeln(serverInformation.specVersion);
}
