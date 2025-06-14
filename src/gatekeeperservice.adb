with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;

package body GateKeeperService is

   package IntegerIO is new Ada.Text_IO.Integer_IO (Integer);
   use IntegerIO;

   capa : Integer := 21;
   procedure setCap (cap : in Integer) is
   begin
      capa := cap;
   end setCap;

   task body GateKeeper is

      package CircularQueue is new CircularQue
        (capacity => capa); -- **  specify size for storage space.
      use CircularQueue;

      rejected : Integer := 0;
      -- Declare food packet counters here.
      vegSold, meatSold, totalSold : Integer := 0;

      MgtDesiredFoodTypeToSell : Food_Type;
      mtgFood                  : Food_Pack;

      Start_Time : Ada.Calendar.Time;
      End_Time   : Ada.Calendar.Time;

   begin

      delay 0.5;  -- allow 1/2 hour to initialize facility.
      Start_Time := Ada.Calendar.Clock;
      End_Time   :=
        Start_Time + 1.0 * 8.0 * 5.0; -- 1.0 sec./hour * 8 hours/days * 5 days

      -- Termiate after lossing 5 customers or time to close has arrived.
      while rejected < 5 and Ada.Calendar.Clock < End_Time
      loop  -- Termiate after lossing 5 customers

      -- In Ada, a "select" statement with multiple "or" options must uniformly
      -- process (randomly) the "accept" statements.  This prevents any single
      -- "accept" from starving the others from service.
         --
         -- Rules for "Select":
         -- 1) If no task are waiting for service, the task sleeps.
         -- 2) If only one of the "accept" entries has a task waiting that task is served.
         -- 3) If sleeping and a task or tasks arrive simultaneously, awake a service the
         --    the first arrival.
   -- 4) If multiple "accepts" have task waiting, service them in random order
         --    to prevent starvation.
         --

         select
            -- new arrivals of food
            accept acceptMessage (newFood : in Food_Pack) do
               if not (circularQueFull) then
                  CircularQueue.acceptMessage (newFood);
                  Put ("GateKeeper insert accepted ");
                  PrintFood_Pack (newFood);
                  New_Line;
               else
                  rejected := rejected + 1;
                  Put (" Rejected by GateKeeper: ");
                  New_Line;
                  PrintFood_Pack (newFood);
                  New_Line;
                  Put (" Rejected = ");
                  Put (rejected);
                  Put (". Sent to another distribution facility!");
                  New_Line (3);
               end if;
            end acceptMessage;
         or
            -- Accept request for distribution from sales
            accept retrieveMessage
              (newFood : out Food_Pack; availableForShipment : out Boolean)
            do
               availableForShipment := False;

               if not (CircularQueue.circularQueEmpty) then
                  availableForShipment := True;

                  MgtDesiredFoodTypeToSell := RandomFoodType;
                  Put ("Mgt Desired Food Type To Sell is: ");
                  PrintFoodType (MgtDesiredFoodTypeToSell);

                  -- set the food type to be in a food pack.
                  setFood_PackFoodType
                    (FoodIn => mtgFood, FoodType => MgtDesiredFoodTypeToSell);
                  if MgtDesiredFoodTypeToSell = Steak then
                     setFood_PackShipment
                       (FoodIn => mtgFood, FoodShipment => 'M');
                  elsif MgtDesiredFoodTypeToSell = Pork then
                     setFood_PackShipment
                       (FoodIn => mtgFood, FoodShipment => 'M');
                  elsif MgtDesiredFoodTypeToSell = Fish then
                     setFood_PackShipment
                       (FoodIn => mtgFood, FoodShipment => 'M');
                  elsif MgtDesiredFoodTypeToSell = Fowel then
                     setFood_PackShipment
                       (FoodIn => mtgFood, FoodShipment => 'M');
                  else
                     setFood_PackShipment
                       (FoodIn => mtgFood, FoodShipment => 'B');
                  end if;

                  -- pass the mtg desired food for the binary search.
                  CircularQueue.setMtgFood (mtgFood);

                  CircularQueue.retrieveMessage (newFood);

                  if getFood_PackFoodType (FoodIn => newFood) /=
                    getFood_PackFoodType (FoodIn => mtgFood)
                  then
                     New_Line (2);
                     Put ("Sorry, no food packets of the ");
                     Put (MgtDesiredFoodTypeToSell'Image);
                     Put (" are currently available.");
                     New_Line (2);
                  end if;

                  Put ("Actual type sold is: ");
                  PrintFood_PackType (newFood);
                  New_Line;
                  --PrintFood_PackShipment( newFood );
                  Put ("Food pack removed by GateKeeper for shipment.");
                  New_Line (2);
               end if;

               if getFood_PackFoodType (FoodIn => newFood) = Steak or
                 getFood_PackFoodType (FoodIn => newFood) = Fish or
                 getFood_PackFoodType (FoodIn => newFood) = Fowel or
                 getFood_PackFoodType (FoodIn => newFood) = Pork
               then
                  meatSold := meatSold + 1;
               else
                  vegSold := vegSold + 1;
               end if;

            end retrieveMessage;
         end select;

         delay 1.1; -- Complete overhead due to accepting or rejecting a request prior to new iteration.
      end loop;

      -- print time in service, statistics such as number food pacekets of meat and non-meat products processed.
      New_Line (2);
      Put ("Hours of operation prior to closing: ");
      Ada.Text_IO.Put_Line (Duration'Image (Ada.Calendar.Clock - Start_Time));
      New_Line (2);

      totalSold := meatSold + vegSold;

      Put ("Meat Sold is: ");
      Put (meatSold);
      New_Line (1);
      Put ("Veg sold is: ");
      Put (vegSold);
      New_Line (1);
      Put ("Total sold is: ");
      Put (totalSold);
      New_Line (2);

      CircularQueue.printList;
      New_Line (2);

   end GateKeeper;

end GateKeeperService;
