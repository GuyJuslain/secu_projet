
with Ada.Text_IO;             use Ada.Text_IO;
with GNAT.Sockets;            use GNAT.Sockets;
WITH Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Streams;   use Ada.Streams;
use type Ada.Streams.Stream_Element_Count;

procedure client is
   Client  : Socket_Type;
   Address : Sock_Addr_Type;
   Channel : Stream_Access; 
   Message : Unbounded_String := To_Unbounded_String("");

   Send   : String := (1 => ASCII.CR, 2 => ASCII.LF, 3 => ASCII.CR, 4 => ASCII.LF);
   Offset : Ada.Streams.Stream_Element_Count;
   Data   : Ada.Streams.Stream_Element_Array (1 .. 256);
   count : Integer := 0;

begin
   GNAT.Sockets.Initialize;
   Create_Socket (Client);

   -- Utilisez l'adresse IP et le port du serveur
   Address.Addr := Inet_Addr("127.0.0.1");
   Address.Port := 12321;

   Connect_Socket (Client, Address);
   Channel := Stream (Client);
   Put_Line("Je me connecte : ");
   Put_Line("");
   delay 0.5;
   Put("ENVOIE DE MESSAGES AU SERVEUR");
   Put("-------------------------------------------------");
   Put_Line("");
   loop
      exit when count = 5;
      delay 0.5;
      put("Saisisez votre message :  ");
      Message := To_Unbounded_String(Get_Line);
      String'Write (Channel, To_String(Message)  & Send);
      count := count + 1;
   end loop;
end client;
