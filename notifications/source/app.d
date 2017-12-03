import ddbus.thin;
import std.stdio;
import std.typecons : Tuple;

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
    conn.getCapabilities().writeln;

    auto serverInformation = conn.getServerInformation();
    writeln(serverInformation.name);
    writeln(serverInformation.vendor);
    writeln(serverInformation.version_);
    writeln(serverInformation.specVersion);
}
