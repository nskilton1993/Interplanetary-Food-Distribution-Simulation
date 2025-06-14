with Food_DataStructures; use Food_DataStructures;
package body CircularQue is

   package IntIO is new Ada.Text_IO.Integer_IO (Integer);
   use IntIO;

   subtype slotindex is
     Natural range 0 .. (capacity - 1);  -- Natural implies >= 0.
   front, rear : slotindex := 1;  -- insert at front, remove from rear.
   mesnum      : Natural range 1 .. (capacity - 1) := 1; -- number in buff

   type vector is array (Integer range <>) of Food_Pack;
   box : vector (0 .. (capacity - 1));

--   box               : array (slotindex) of message; -- circular buffer
   maxMessages : Natural := capacity - 1; -- Integers >= 0.

   l, m, temp : Integer;
   mtgmsg     : Food_Pack;
   isDone     : Boolean := False;

   procedure acceptMessage (msg : in Food_Pack)
   is  -- ** modify for placing in dual stacks
   begin
      if mesnum < maxMessages then  -- reserve space and insert msg.
--         rear       := (rear + 1) mod capacity;  -- implement wrap-around.
--         box (rear) := msg;

         temp := rear;
         while temp >= front and
           getFood_PackFoodType (FoodIn => box (temp)) >
             getFood_PackFoodType (FoodIn => msg)
         loop
            box (temp + 1) := box (temp);
            temp           := temp - 1;
         end loop;

         if temp = rear then         --last item
            box (rear + 1) := msg;
         elsif temp < front then     --first item
            box (front) := msg;
         else                        --interior item
            box (temp + 1) := msg;
         end if;

         rear   := rear + 1;
         mesnum := mesnum + 1;
      else
         Put ("ERROR - Message rejected - queue is full!");
         New_Line (2);
      end if;

   end acceptMessage;

   procedure retrieveMessage (msg : out Food_Pack)
   is  -- ** modify in dual stacks to return highest priority food
   begin
      if mesnum > 0 then  -- remove message if buff not empty
--         front :=
--           (front + 1) mod
--           capacity;  -- front trails the next message by 1.  rear is the actual last msg.
--         msg := box (front);

         -- uniform binary search
         l := (rear / 2);
         m := (rear / 2);
         loop

            -- adding this check always found the result.
            if getFood_PackFoodType (FoodIn => mtgmsg) =
              getFood_PackFoodType (FoodIn => box (l))
            then
--               Put("FOUND!!!!!!!!!!!!!!!!!!!!!!!!");
               exit;
            end if;

            if getFood_PackFoodType (FoodIn => mtgmsg) <
              getFood_PackFoodType (FoodIn => box (l))
            then
--               Put("1!");
--               Put(mtgmsg'Image);
--               Put(box(l)'Image);
               if m = 0 then
                  exit; -- search fails
               else
                  l := l - (m / 2);
                  m := (m / 2);
               end if;
            elsif getFood_PackFoodType (FoodIn => mtgmsg) >
              getFood_PackFoodType (FoodIn => box (l))
            then
--               Put("2!!");
--               Put(mtgmsg'Image);
--               Put(box(l)'Image);
               if m = 0 then
                  exit; -- search fails
               else
                  l := l + (m / 2);
                  m := (m / 2);
               end if;
            else -- search successful
--               Put("3!!!");
--               Put(mtgmsg'Image);
--               Put(box(l)'Image);
               msg := box (l);
               for I in l .. (rear - 1) loop
                  box (I + 1) := box (I);
               end loop;
               exit;
            end if;
         end loop;

         if m = 0 then
            msg := box (rear);
         else
            msg := box (l);
            for I in l .. (rear - 1) loop
               box (I) := box (I + 1);
            end loop;
         end if;

         rear   := rear - 1;
         mesnum := mesnum - 1;
      else
         Put ("ERROR - No message in the queue to retrieve!");
         New_Line (2);
      end if;
   end retrieveMessage;

   function CircularQueEmpty return Boolean is
   begin
      if mesnum > 0 then
         return False;
      else
         return True;
      end if;
   end CircularQueEmpty;

   function CircularQueFull return Boolean is  -- ** modify for dual stacks
   begin
      if mesnum < maxMessages then
         return False;
      else
         return True;
      end if;
   end CircularQueFull;

   -- set the mtg food for use in the binary seach.
   procedure setMtgFood (msg : in Food_Pack) is
   begin
      mtgmsg := msg;
   end setMtgFood;

   procedure printList is
   begin
      -- Testing for consistant order
      for I in front .. rear loop
         Put (box (I)'Image);
      end loop;
      New_Line (2);
   end printList;

end CircularQue;
