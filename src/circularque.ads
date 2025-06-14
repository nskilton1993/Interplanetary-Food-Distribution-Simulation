with Ada.Text_IO; use Ada.Text_IO;
with Food_DataStructures; use Food_DataStructures;

generic
   -- Add generic parameter to determine the size of the storage space.
   capacity : Natural := 21;

package CircularQue is

   procedure acceptMessage (msg : in Food_Pack);

   procedure retrieveMessage (msg : out Food_Pack);

   function circularQueEmpty return Boolean;

   function circularQueFull return Boolean;

   procedure setMtgFood (msg : in Food_Pack);

   procedure printList;

   --Add method (function or procedure) for inserting at front of queue here and in body.

end CircularQue;
