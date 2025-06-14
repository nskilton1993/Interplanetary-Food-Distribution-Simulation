# 🛰️ Interplanetary Food Distribution Simulation

This is a multitasked Ada simulation designed to model an interplanetary food distribution system. It features dynamically defined food generators, multiple points of sale (POS), and a centralized warehouse (GateKeeper) that stores food packets in a **sorted linear list** using custom-built data structures. The simulation includes **binary search, dynamic insertion/deletion, and real-time task scheduling**, offering a rich demonstration of data structures in a concurrent setting.

## Running the program
Program runs from command promt, best to save the output.
Download the file
copy the lines below in command promt

cd downloads
productdistributionmain.exe >> output.txt

program will run for ~40 sec.

---

## 🎯 Objective

Build a multitasked system that:
- Accepts incoming food shipments concurrently
- Maintains a sorted list of food packets (no prebuilt containers)
- Services dynamic POS requests using binary search
- Simulates randomized arrivals and sales using exponential time delays
- Prevents race conditions via a centralized "GateKeeper" queue system

---

## 📦 Food Types

The system uses an enumeration of food types:

```ada
type Food_Type is (Wheat, Corn, Rice, Potatoes, Squash, Tomato, Steak, Pork, Fish, Fowel);
subtype GrainVegetable is Food_Type range Wheat .. Tomato;
