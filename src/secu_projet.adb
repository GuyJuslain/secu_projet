
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with GNAT.Sockets;      use GNAT.Sockets;
with Ada.Streams;       use Ada.Streams;

procedure serveur is

   Receiver   : GNAT.Sockets.Socket_Type;
   Connection : GNAT.Sockets.Socket_Type;
   Client     : GNAT.Sockets.Sock_Addr_Type;
   Channel    : GNAT.Sockets.Stream_Access;
   Offset : Ada.Streams.Stream_Element_Count;
   Data   : Ada.Streams.Stream_Element_Array (1 .. 256);



begin
   Create_Socket (Socket => Receiver);
   Set_Socket_Option(Socket => Receiver, Level  => Socket_Level, Option => (Name => Reuse_Address, Enabled => True));
   Bind_Socket(Socket => Receiver, Address => (Family => Family_Inet, Addr => Inet_Addr ("127.0.0.1"), Port => 12321));
   Listen_Socket (Socket => Receiver);

   loop
      Accept_Socket(Server => Receiver, Socket  => Connection, Address => Client);
      Put_Line("Client connected from " & GNAT.Sockets.Image (Client));
      Channel := Stream (Connection);
      loop
         Ada.Streams.Read (Channel.All, Data, Offset);
         exit when Offset = 0;
         for I in 1 .. Offset loop
            Ada.Text_IO.Put (Character'Val(Data(I)));
         end loop;
      end loop;
   end loop;
end serveur;