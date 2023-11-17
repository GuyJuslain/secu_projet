
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;
with GNAT.Sockets;      use GNAT.Sockets;
with Ada.Streams;       use Ada.Streams;
WITH Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;

procedure serveur is

   Receiver       : GNAT.Sockets.Socket_Type;
   Connection     : GNAT.Sockets.Socket_Type;
   Client         : GNAT.Sockets.Sock_Addr_Type;
   Channel        : GNAT.Sockets.Stream_Access;
   Offset         : Ada.Streams.Stream_Element_Count;      --off
   Data           : Ada.Streams.Stream_Element_Array (1 .. 1);
   receive_message   : Unbounded_String;
   char_lu : Character := ' ';

begin
   Create_Socket (Socket => Receiver);
   Set_Socket_Option(Socket => Receiver, Level  => Socket_Level, Option => (Name => Reuse_Address, Enabled => True));
   Bind_Socket(Socket => Receiver, Address => (Family => Family_Inet, Addr => Inet_Addr ("127.0.0.1"), Port => 12321));
   Listen_Socket (Socket => Receiver);

   -- Boucle pour l'écoute des connexions

   loop        
      Accept_Socket(Server => Receiver, Socket  => Connection, Address => Client);
      Put_Line("Client connected from " & GNAT.Sockets.Image (Client));
      Channel := Stream (Connection);

   -- On lit les messages qui arrivent. On lit La serie de message que le client connecté envoie

      loop     
         receive_message := To_Unbounded_String("");

   -- On boucle pour lire un message entier (Lecture caractere par caractere)

         loop     
            Ada.Streams.Read(Channel.All, Data, Offset);
            char_lu := Character'Val(Data(1));
            exit when char_lu = ASCII.LF;    -- On lit caractere par carctere jusqu'à ce qu'on ait un caractère fin de ligne (LF)
            Append(receive_message, char_lu);
 --           receive_message := receive_message & char_lu'Image;
         end loop;
         Put(To_String(receive_message));
         Put_Line("");
         exit when Offset = 0;   
      end loop;
      
   end loop;
end serveur;

--https://stackoverflow.com/questions/21577579/how-to-properly-read-and-write-on-sockets-using-ada

--https://en.wikibooks.org/wiki/Ada_Programming/Libraries/GNAT.Sockets


--https://www.adaic.org/resources/add_content/standards/05rm/html/RM-J-5.html