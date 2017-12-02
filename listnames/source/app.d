import ddbus.thin;
import std.stdio;

void main()
{
    // 新規のD-Busコネクションを作成する.
    Connection conn = connectToBus();

    // BUSの一覧を要求するメッセージを作成する.
    Message msg = Message("org.freedesktop.DBus", "/",
                          "org.freedesktop.DBus", "ListNames");

    // D-Bus経由でメッセージを投げて返信を待つ.
    // デフォルトではタイムアウト値: -1で無限に待ち続けるが
    // ここでは2秒に設定する.
    Message reply = conn.sendWithReplyBlocking(msg, 2000);

    // 取得したメッセージの最初の引数にバスの一覧情報が入る.
    foreach (name; reply.read!(string[])())
        writeln(name);
}
