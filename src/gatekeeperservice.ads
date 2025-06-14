with Food_DataStructures;    use Food_DataStructures;
with Stats_FoodDistribution; use Stats_FoodDistribution;
with CircularQue;

package GateKeeperService is

   procedure setCap (cap : in Integer);

   task GateKeeper is
      -- accept Food_Packs from interplanetary vesssels.
      entry acceptMessage (newFood : in Food_Pack);

      --Allow sales to retrive the repackaged Food_Packs.
      entry retrieveMessage
        (newFood : out Food_Pack; availableForShipment : out Boolean);

   end GateKeeper;

end GateKeeperService;
