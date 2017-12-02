import ddbus;
import std.stdio;

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
}
